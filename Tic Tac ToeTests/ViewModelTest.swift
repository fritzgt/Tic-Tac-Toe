//
//  ViewModelTest.swift
//  Tic Tac ToeTests
//
//  Created by FGT MAC on 5/26/21.
//

import XCTest
@testable import Tic_Tac_Toe

class ViewModelTest: XCTestCase {
    
    var viewModel: GameViewModel?
    
    override func setUp() {
        viewModel = GameViewModel()
    }
    
    func testScoreIncrement() throws {
        
        viewModel?.processPlayerMove(for: 0)
        viewModel?.processPlayerMove(for: 1)
        viewModel?.processPlayerMove(for: 2)
        
        XCTAssertEqual(viewModel?.humanScore, "1")
    }

    func testMoves() {
 
        viewModel?.moves.append(Move(player: .player1, boardIndex: 1))
        
        var playerCounter = 0
        var unoccupiedSpaceCounter = 0
        
        for move in viewModel!.moves {
            if move?.player == .player1{
                playerCounter += 1
            }else{
                unoccupiedSpaceCounter += 1
            }
        }
        
        XCTAssertEqual(playerCounter, 1)
        
        XCTAssertNotEqual(unoccupiedSpaceCounter, 10)
    }
    
    func testResetGame()  {
        viewModel?.resetGame()
        var counter = 0
        for move in viewModel!.moves {
            if move?.player == .none{
                counter += 1
            }
        }
        
        XCTAssertEqual(counter, 9)
        
    }

}
