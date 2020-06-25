//
//  GameScreenViewController.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class GameScreenViewController: UIViewController {
    
    fileprivate let bag = DisposeBag()
    
    private enum ButtonTags:Int{
        case buttonCorrect = 1000
        case buttonWrong = 1001
    }
    
    let userDefaults = UserDefaults.standard
    
    //MARK: Outlets
    @IBOutlet weak var labelScoreRoundInfo: UILabel!
    @IBOutlet weak var labelCurrentWord: UILabel!
    @IBOutlet weak var labelCurrentWordTranslation: UILabel!
    @IBOutlet weak var buttonCorrect: UIButton!
    @IBOutlet weak var buttonWrong: UIButton!
    @IBOutlet weak var buttonStartGame: UIButton!
    @IBOutlet weak var labelWaiting: UILabel!
    @IBOutlet weak var labelMaxScore: UILabel!
    
    @IBOutlet weak var startGameStackView: UIStackView!
    
    private var timer:Timer?
    var gameViewModel = FallingWordsGameViewModel()
    
    //MARK: RxSwift Variables
    var roundObservable: Observable<Int>{
        return gameViewModel.round.asObservable()
    }
    
    var totalScoreObservable: Observable<Int>{
        return gameViewModel.totalScore.asObservable()
    }
    
    private var isGameRunning:BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var isGameRunningObservable: Observable<Bool>{
        return isGameRunning.asObservable()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Reset Button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Reset", style: .done, target: self, action: #selector(self.resetButtonClicked(sender:)))
        
        bindUI()
    }
    
    func bindUI(){
        Observable.combineLatest(roundObservable, totalScoreObservable).subscribe(onNext: {(round,totalScore) in
            self.labelScoreRoundInfo.text = "Score: \(totalScore)      Round: \(round)"
            
        }).disposed(by: bag)
        
        isGameRunningObservable.subscribe(onNext: {(isGameRunning) in
            
            if isGameRunning{
                self.configureUIStarted()
            }
            else{
                self.configureUINotStarted()
            }
            
        }).disposed(by: bag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    //MARK: Buttons Action Methods
    @objc func resetButtonClicked(sender: UIBarButtonItem) {
        isGameRunning.accept(false)
    }
    
    @IBAction func buttonStartGameClicked(_ sender: Any) {
        isGameRunning.accept(true)
    }
    
    @IBAction func btnAnswerClicked(_ sender: Any) {
        guard sender is UIButton else {
            return
        }
        let button = sender as! UIButton
        let answerGiven:Bool
        switch button.tag {
        case ButtonTags.buttonCorrect.rawValue:
            answerGiven = true
            break
            
        case ButtonTags.buttonWrong.rawValue:
            answerGiven = false
            break
            
        default:
            answerGiven = false
            break
        }
        
        gameViewModel.submitAnswer(answer: answerGiven,completion: {(score,result) in
            button.backgroundColor = result ? UIColor.green : UIColor.red
            self.labelCurrentWord.text = "\(score) points scored"
        })
        breakBeforeNext()
    }
    
    func startNewRound(){
        self.gameViewModel.startNewRound(completion: {(word,translation,error,shouldEndGame) in
            
            guard error == nil else{
                self.showAlert(title:"Error",message: error?.message ?? ConstantString.genericErrorMessage)
                return
            }
            
            guard shouldEndGame == false else{
                Utility.sharedInstance.setMaxScore(score: self.gameViewModel.totalScore.value)
                self.isGameRunning.accept(false)
                self.showAlert(title:"Game Ended",message: "Total Points Scored : \(self.gameViewModel.totalScore.value)")
                return
            }
            
            self.labelCurrentWordTranslation.text = translation
            self.labelCurrentWord.text = word
            self.buttonWrong.backgroundColor = UIColor(named: "themeOrange")
            self.buttonCorrect.backgroundColor = UIColor(named: "themeOrange")
            self.view.layoutIfNeeded()
        })
    }
}

//MARK: Game Flow Methods
extension GameScreenViewController{
    
    func fallWord(){
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func fireTimer() {
        self.animShow()
        startNewRound()
    }
    
    func animShow(){
        self.labelCurrentWordTranslation.layer.removeAllAnimations()
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.fromValue = 40  //Top Y
        animation.toValue = self.view.frame.height-40  //Bottom Y
        animation.duration = 40 * 0.10 //duration * speed
        animation.repeatCount = Float(ApplicationConfiguration.maxRounds)
        animation.autoreverses = false
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        self.labelCurrentWordTranslation.layer.add(animation, forKey: "position.y")
    }
    
    func breakBeforeNext(){
        timer?.invalidate();
        
        configurebreakBeforeNextView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.configureCanNowPlayView()
            self.fallWord()
        }
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UI Configuration Methods
extension GameScreenViewController{
    
    func configureUINotStarted(){
        buttonCorrect.isHidden = true
        buttonWrong.isHidden = true
        labelCurrentWord.isHidden = true
        labelScoreRoundInfo.isHidden = true
        startGameStackView.isHidden = false
        labelWaiting.isHidden = true
        
        if let maxScore = Utility.sharedInstance.getMaxScore() {
            labelMaxScore.isHidden = false
            labelMaxScore.text = "High Score : \(maxScore)"
        }
        else
        {
            labelMaxScore.isHidden = true
        }
        
        self.labelCurrentWordTranslation.layer.removeAllAnimations()
        timer?.invalidate()
        gameViewModel.startNewGame()
    }
    
    func configureUIStarted(){
        buttonCorrect.isHidden = false
        buttonWrong.isHidden = false
        labelCurrentWord.isHidden = false
        labelScoreRoundInfo.isHidden = false
         startGameStackView.isHidden = true
        
        labelScoreRoundInfo.text = "Starting Game..."
        labelCurrentWord.text = "Word will appear here..."
        
        breakBeforeNext()
    }
    
    func configurebreakBeforeNextView(){
        labelWaiting.isHidden = false
        self.labelCurrentWordTranslation.isHidden = true
        buttonWrong.isUserInteractionEnabled = false
        buttonCorrect.isUserInteractionEnabled = false
    }
    
    func configureCanNowPlayView(){
        labelWaiting.isHidden = true
        buttonWrong.isUserInteractionEnabled = true
        buttonCorrect.isUserInteractionEnabled = true
        labelCurrentWordTranslation.isHidden = false
        labelWaiting.isHidden = true
    }
}
