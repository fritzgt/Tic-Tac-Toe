//
//  TicTacToeModel.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/20/21.
//

import Foundation

// MARK: - Move
struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        //If is player 1 = X computer or player 2 = O
        return player == .player1 ? "xmark" : "circle"
    }
}


// MARK: - Player
enum Player {
    case player1, computer, player2
}
