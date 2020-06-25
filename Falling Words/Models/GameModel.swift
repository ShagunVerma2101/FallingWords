//
//  GameModel.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import UIKit

class GameModel {
    let userdefaults = UserDefaults.standard
    
    private var word:String = ""
    private var translation:TranslatedOption!
    private var language:Language = Language.English
    
    var wordsMap = Dictionary<String, [TranslatedOption]>()
    
    init() {
        configureWordsMap()
    }
    
    //Creates a map for translation and their options
    func configureWordsMap(){
        if let url = Bundle.main.url(forResource: "words", withExtension: "json") {
            do {
                let isEnglishToSpanish = userdefaults.value(forKey: UserDefaultKeys.LanguageSelected.rawValue) as! String == Language.English.rawValue
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let wordsList = try decoder.decode([WordTranslation].self, from: data)
                if (isEnglishToSpanish){
                    for word in wordsList{
                        //Putting in 3 options for every single word
                        wordsMap.updateValue([TranslatedOption.init(word: word.text_spa, coorect: true),TranslatedOption.init(word: wordsList.randomElement()!.text_spa, coorect: false),TranslatedOption.init(word: wordsList.randomElement()!.text_spa, coorect: false)], forKey: word.text_eng)
                    }
                }
                else {
                    for word in wordsList{
                        //Putting in 3 options for every single word
                        wordsMap.updateValue([TranslatedOption.init(word: word.text_eng, coorect: true),TranslatedOption.init(word: wordsList.randomElement()!.text_eng, coorect: false),TranslatedOption.init(word: wordsList.randomElement()!.text_eng, coorect: false)], forKey: word.text_spa)
                    }
                }
            } catch {
                print("error:\(error)")
            }
        }
    }
}
