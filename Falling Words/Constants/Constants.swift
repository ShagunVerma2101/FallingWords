//
//  Constants.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import Foundation
import UIKit

public enum UserDefaultKeys : String {
    case LanguageSelected = "languageSelected"
    case LevelSelected = "levelSelected"
    case MaxPointsScored = "maxPointsScored"
}

public enum LevelSelected : String {
    case Beginner = "Beginner"
    case Intermediate = "Intermediate"
}

public enum Language:String {
    case English = "English"
    case Spanish = "Spanish"
}

struct ApplicationConfiguration {
    static let maxRounds = 10
}

struct ScreenIdentifiers {
    static let gameScreenViewController = "GameScreenViewController"
}

struct StoryBoards {
    static let main = "Main"
}
