//
//  Utility.swift
//  Falling Words
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import Foundation

class Utility:NSObject {
    
    static let sharedInstance = Utility()
    let userDefaults = UserDefaults.standard
    private override init() {}
    
    func setMaxScore(score:Int){
        let previousScore = userDefaults.value(forKey: UserDefaultKeys.MaxPointsScored.rawValue)
        if let previousScore = previousScore as? Int {
            if (previousScore<score){
                userDefaults.set(score, forKey: UserDefaultKeys.MaxPointsScored.rawValue)
            }
        }else{
            userDefaults.set(score, forKey: UserDefaultKeys.MaxPointsScored.rawValue)
        }
    }
    
    func getMaxScore() -> Int?{
        return userDefaults.value(forKey: UserDefaultKeys.MaxPointsScored.rawValue) as? Int ?? nil
    }
    
}
