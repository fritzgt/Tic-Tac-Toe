//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/12/21.
//

import SwiftUI


struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisable = false
    @State private var alertItem: AlertItem?
        
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            Circle()
                                .foregroundColor(.blue).opacity(0.5)
                                .frame(width: geometry.size.width/3 - 15,
                                       height: geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            //Prevents user from overwriting an occupied space
                            if isSquareOccupied(in: moves, forIndex: i){ return }
                            
                            //1.User move
                            moves[i] = Move(player: .human, boardIndex: i)
                            
                            //Check for win conditions
                            if checkWinCondition(for: .human, in: moves){
                                alertItem =  AletContext.humanWin
                                return
                            }
                            if checkForDraw(in: moves){
                                alertItem =  AletContext.draw
                                return
                            }
                            
                            isGameboardDisable = true//Prevents user from tapping another space before the computer makes a move
                            
                            //2.After a half sec delay computer will make a move
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                
                                isGameboardDisable = false
                                //Check for win conditions
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem =  AletContext.computerWin
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    alertItem =  AletContext.draw
                                    return
                                }
                                
                            }
                            
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameboardDisable)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.butonTitle, action: { resetGame() }))
            })
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
   
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        //If AI can win, then win
        //1.Posible win positions
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        //2.Remove nils from all positions and then filter to get only computer positions
        let computerMoves = moves.compactMap { $0 }.filter{$0.player == .computer}
        //3.Get all the indexes of the computer positions
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        //4.Iterate over the posible win positions
        for pattern in winPattern {
            //1.Check each patter and substract/remove the current computer position
            let winPositions = pattern.subtracting(computerPositions)
            //2.If is only one move needed to win
            if winPositions.count == 1 {
                //1.Check is the one position to win is available
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                //2.Take position if is available and return to prevent the rest of the code from running
                if isAvailable { return winPositions.first!}
            }
        }
        
        //If AI can't win, then block(Similar to above but this time we check for human moves to block
        
        //1.Remove nils from all positions and then filter to get only computer positions
        let humanMoves = moves.compactMap { $0 }.filter{$0.player == .human}
        //2.Get all the indexes of the human positions
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        //3.Iterate over the posible win positions
        for pattern in winPattern {
            //1.Check each patter and substract/remove the current computer position
            let winPositions = pattern.subtracting(humanPositions)
            //2.If is only one move needed to win
            if winPositions.count == 1 {
                //1.Check is the one position to win is available
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                //2.Take position if is available and return to prevent the rest of the code from running
                if isAvailable { return winPositions.first!}
            }
        }
        
        //If AI cant block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) { return centerSquare }
        
        //If AI can't take middle square, then random available square
        var movePosition = Int.random(in: 0..<9)
        
        //While square is occupied try another position
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        //when false this will run to return a new position for the computer
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in move: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        //First remove all nils -> then chain a filter the current player's moves
        let playerMoves = moves.compactMap { $0 }.filter{$0.player == player}
        //Get the position/index of each of the payer's moves
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        //Iterate over the winPattern and check if the current moves have a win condition
        for pattern in winPattern where pattern.isSubset(of: playerPositions) {return true}
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        //CompactMap will remove the nils to check the count of moves, if = 9 then thats the max and is a drawn
        return moves.compactMap{ $0 }.count == 9
    }
    
    func resetGame() {
        moves =  Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
