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
    static let player1 = AlertItem(title: Text("🏆"),
                             message: Text("Congratulations Player 1 have won!"),
                             butonTitle: Text("Continue"))
    
    static let player2 = AlertItem(title: Text("🏆"),
                             message: Text("Congratulations Player 2 have won!"),
                             butonTitle: Text("Continue"))
    
    static let computer = AlertItem(title: Text("❌"),
                             message: Text("A.I have won."),
                             butonTitle: Text("Play again"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("Try again."),
                             butonTitle: Text("Play again"))
}
