//
//  WordTranslation.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import Foundation

struct WordTranslation : Decodable {
    var text_eng:String
    var text_spa:String
    
    init(english:String, spanish:String) {
        text_eng = english
        text_spa = spanish
    }
}

struct TranslatedOption : Decodable {
    var translation:String
    var isCorrect:Bool
  
    init(word:String, coorect:Bool) {
        translation = word
        isCorrect = coorect
    }
}
