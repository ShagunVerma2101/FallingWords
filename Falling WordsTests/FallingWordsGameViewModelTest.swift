//
//  FallingWordsGameViewModelTest.swift
//  Falling WordsTests
//
//  Created by Shagun Verma on 21/06/20.
//  Copyright © 2020 Shagun Verma. All rights reserved.
//

import XCTest
@testable import Falling_Words

class FallingWordsGameViewModelTest: XCTestCase {
    
    private var testgameViewModel: FallingWordsGameViewModel?
    
    override func setUp() {
        testgameViewModel = FallingWordsGameViewModel()
    }
    
    override func tearDown() {
        testgameViewModel = nil
    }
    
    func testStartNewGameInit(){
        XCTAssertNotNil(testgameViewModel)
    }
    
    func testStartNewRound(){
        testgameViewModel = FallingWordsGameViewModel()
        testgameViewModel?.startNewRound(completion: {(word,translation,error,endGame) in
            XCTAssertNil(error)
            XCTAssertNotNil(word)
            XCTAssertNotNil(translation)
        })
    }
    
    func testStartNewRoundAfterCorrectAnswer(){
        testgameViewModel?.startNewGame()
        testgameViewModel?.computeScore(result: true, negativeMarking: -2)
        testgameViewModel?.startNewRound(completion: {(word,translation,error,endGame) in
            XCTAssertNil(error)
            //Score starts from 0 and should return +5 in this function
            XCTAssertEqual(self.testgameViewModel?.totalScore.value, 5, "Score computed is wrong")
            //Round starts from 1 when start new game and should return +1 in this function
            XCTAssertEqual(self.testgameViewModel?.round.value, 1, "Round Incrementing is wrong")
        })
    }
    
    func testStartNewRoundAfterWrongAnswer(){
        testgameViewModel?.startNewGame()
        testgameViewModel?.computeScore(result: false, negativeMarking: -2)
        testgameViewModel?.startNewRound(completion: {(word,translation,error,endGame) in
            XCTAssertNil(error)
            //Score starts from 0 and should return -2 in this function
            XCTAssertEqual(self.testgameViewModel?.totalScore.value, -2, "Score computed is wrong")
            //Round starts from 0 when start new game and should return +1 in this function
            XCTAssertEqual(self.testgameViewModel?.round.value, 1, "Rou.nd Incrementing is wrong")
        })
    }
    
    func testForEndGameAfterMaxRounds(){
        testgameViewModel?.startNewGame()
        testgameViewModel?.computeScore(result: false, negativeMarking: -2)
        
        var i = 0
        let maxRounds = ApplicationConfiguration.maxRounds
        testgameViewModel?.startNewRound(completion: {(word,translation,error,endGame) in
            
            XCTAssertNotNil(self.testgameViewModel?.totalScore)
            
            if ((self.testgameViewModel?.round.value)! <= maxRounds){
                XCTAssertEqual(endGame, false)
            }
            else{
                XCTAssertEqual(endGame, true)
            }
        })
        i+=1
    }
}
