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
        
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            Circle()
                                .foregroundColor(.purple).opacity(0.5)
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
                            isGameboardDisable = true//Prevents user from tapping another space before the computer makes a move
                            
                            //Check for win conditions
                            if checkWinCondition(for: .human, in: moves){
                                print("Human won")
                            }
                            if checkForDraw(in: moves){
                                print("No winner")
                                return
                            }
                            
                            //2.After a half sec delay computer will make a move
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameboardDisable = false
                                
                                //Check for win conditions
                                if checkWinCondition(for: .computer, in: moves){
                                    print("A.I won")
                                }
                                
                                if checkForDraw(in: moves){
                                    print("No winner")
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
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
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
