//
//  FallingWordsGameViewModel.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class FallingWordsGameViewModel {
    
    private enum ScoreDelta: Int{
        case correctAnswer = 5
        case wrongAnswer = -2
    }
    
    let userdefaults = UserDefaults.standard
    var gameModel:GameModel!
    private var currentTranslationOption:TranslatedOption?
    private var currentWord:String?
    var round:BehaviorRelay<Int>
    var totalScore:BehaviorRelay<Int>
    
    private var pointsScored:Int
    
    init(){
        round = BehaviorRelay(value: 0)
        totalScore = BehaviorRelay(value: 0)
        pointsScored = 0
        gameModel = GameModel()
    }
    
    func startNewGame(){
        round.accept(0)
        totalScore.accept(0)
        pointsScored = 0
    }
    
    func startNewRound(completion: @escaping (_ word:String,_ translation:String,_ error:ErrorValue?,_ endGame:Bool) -> Void){
        round.accept(round.value+1)
        pointsScored = 0
        configureNewWordSet()
        
        guard self.currentWord != nil else {
            completion ("","",ErrorValue(message:"Word Not Available"),true)
            return
        }
        
        let endGame = round.value <= ApplicationConfiguration.maxRounds ? false : true
        
        completion (self.currentWord!,self.currentTranslationOption!.translation,nil,endGame)
    }
    
    func submitAnswer(answer: Bool, completion:@escaping (_ pointsScored:Int,_ result:Bool) -> Void) {
        guard currentTranslationOption != nil else {return}
        
        let correctAnswer = currentTranslationOption!.isCorrect
        let isLevelIntermediate = userdefaults.value(forKey: UserDefaultKeys.LevelSelected.rawValue) as! String == LevelSelected.Intermediate.rawValue
        
        var wrongAnswerDeduction = 0
        if (isLevelIntermediate){
            wrongAnswerDeduction = ScoreDelta.wrongAnswer.rawValue
        }
        
        let result = answer == correctAnswer
        computeScore(result: result,negativeMarking: wrongAnswerDeduction)
        
        completion(pointsScored,result)
    }
    
    func computeScore(result:Bool,negativeMarking:Int){
        if (result){
            pointsScored = ScoreDelta.correctAnswer.rawValue
            totalScore.accept(totalScore.value + pointsScored)
        }
        else{
            pointsScored = negativeMarking
            totalScore.accept(totalScore.value + pointsScored)
        }
    }
    
    func configureNewWordSet() {
        guard gameModel.wordsMap.count > 0 else {
            return
        }
        let word = gameModel.wordsMap.keys.randomElement()!
        let answerOptions = gameModel.wordsMap[word]!
        let translation = answerOptions.randomElement()!
        currentWord = word
        currentTranslationOption = translation
    }
}
