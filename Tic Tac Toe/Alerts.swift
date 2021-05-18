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
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Congratulations you have won!"),
                             butonTitle: Text("Play again"))
    
    static let computerWin = AlertItem(title: Text("You Lost"),
                             message: Text("A.I have won."),
                             butonTitle: Text("Play again"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("Try again."),
                             butonTitle: Text("Play again"))
}
