//
//  HomeViewController.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    private enum ButtonTags:Int{
        case btnEnglishToSpanish = 1000
        case btnSpanishToEnglish = 1001
        case btnBeginnerLevel = 2000
        case btnIntermediateLevel = 2001
    }
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var btnEnglishToSpanish: UIButton!
    @IBOutlet weak var btnSpanishToEnglish: UIButton!
    
    @IBOutlet weak var btnBeginnerLevel: UIButton!
    @IBOutlet weak var btnIntermediateLevel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialParameters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: Configuration Methods
    func setInitialParameters() {
        
        //Setting English as pre selected option
        btnEnglishToSpanish.isSelected = true
        userDefaults.set(Language.English.rawValue, forKey: UserDefaultKeys.LanguageSelected.rawValue)
        btnSpanishToEnglish.isSelected = false
        
        //Setting Beginner as pre selected option
        btnBeginnerLevel.isSelected = true
        userDefaults.set(LevelSelected.Beginner.rawValue, forKey: UserDefaultKeys.LevelSelected.rawValue)
        btnIntermediateLevel.isSelected = false
    }
    
    // MARK: Button Actions
    @IBAction func startPlayingButtonClicked(_ sender: Any) {
        let vc = UIStoryboard.init(name: StoryBoards.main, bundle: nil).instantiateViewController(withIdentifier: ScreenIdentifiers.gameScreenViewController)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func chooseLanguageButtonTapped(_ sender: Any) {
        guard sender is UIButton else {
            return
        }
        
        let button = sender as! UIButton
        switch button.tag {
            
        //Button Action - English To Spanish Selected
        case ButtonTags.btnEnglishToSpanish.rawValue:
            btnEnglishToSpanish.isSelected = true
            btnSpanishToEnglish.isSelected = false
            userDefaults.set(Language.English.rawValue, forKey: UserDefaultKeys.LanguageSelected.rawValue)
            break
            
        //Button Action - Spanish To English Selected
        case ButtonTags.btnSpanishToEnglish.rawValue:
            btnSpanishToEnglish.isSelected = true
            btnEnglishToSpanish.isSelected = false
            userDefaults.set(Language.Spanish.rawValue, forKey: UserDefaultKeys.LanguageSelected.rawValue)
            break
            
        default:
            break
        }
    }
    
    @IBAction func selectLevelButtonTapped(_ sender: Any) {
        guard sender is UIButton else {
            return
        }
        
        let button = sender as! UIButton
        switch button.tag {
            
        //Button Action - Beginner Level Selected
        case ButtonTags.btnBeginnerLevel.rawValue:
            btnBeginnerLevel.isSelected = true
            btnIntermediateLevel.isSelected = false
            userDefaults.set(LevelSelected.Beginner.rawValue, forKey: UserDefaultKeys.LanguageSelected.rawValue)
            break
            
        //Button Action - Intermediate Level Selected
        case ButtonTags.btnIntermediateLevel.rawValue:
            btnBeginnerLevel.isSelected = false
            btnIntermediateLevel.isSelected = true
            userDefaults.set(LevelSelected.Intermediate.rawValue, forKey: UserDefaultKeys.LevelSelected.rawValue)
            break
            
        default:
            break
        }
    }
}
