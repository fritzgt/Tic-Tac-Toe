//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/17/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var butonTitle: Text
}


struct AlertContext {
    static let player1 = AlertItem(title: Text("Player 1 Win!"),
                             message: Text("Congratulations you have won!"),
                             butonTitle: Text("Play again"))
    
    static let player2 = AlertItem(title: Text("Player 2 Win!"),
                             message: Text("Congratulations you have won!"),
                             butonTitle: Text("Play again"))
    
    static let computer = AlertItem(title: Text("You Lost"),
                             message: Text("A.I have won."),
                             butonTitle: Text("Play again"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("Try again."),
                             butonTitle: Text("Play again"))
}
