//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/18/21.
//

import SwiftUI

//Final is use to prevent other classes from inheriting from this one
//ObservableObject To manage state
final class GameViewModel: ObservableObject {
    
    // MARK: - Properties
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisable = false
    @Published var alertItem: AlertItem?
    @Published var humanScore: String = "0"
    @Published var computerScore: String = "0"
    @Published var difficultyLevel: Int = 1 {
        didSet{
            //If user changes the difficulty level reset game
            resetCounter()
            resetGame()
        }
    }
    private var scores: (human: Int, computer: Int) =  (human: 0, computer: 0)
    
    // MARK: - Methods
    func processPlayerMove(for position: Int) {
        //Prevents user from overwriting an occupied space
        if isSquareOccupied(in: moves, forIndex: position){ return }
        
        //1.User move
        
        moves[position] = Move(player: .human, boardIndex: position)
        
        //Check for win conditions
        if checkWinCondition(for: .human, in: moves){
            alertItem =  AlertContext.humanWin
            increaseCounter(for: .human)
            return
        }
        if checkForDraw(in: moves){
            alertItem =  AlertContext.draw
            return
        }
        
        isGameboardDisable = true//Prevents user from tapping another space before the computer makes a move
        
        //2.After a half sec delay computer will make a move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            isGameboardDisable = false
            //Check for win conditions
            if checkWinCondition(for: .computer, in: moves){
                alertItem =  AlertContext.computerWin
                increaseCounter(for: .computer)
                return
            }
            
            if checkForDraw(in: moves){
                alertItem =  AlertContext.draw
                return
            }
            
        }
    }
    
    func resetGame() {
        moves =  Array(repeating: nil, count: 9)
    }
    
    // MARK: - Private Methods
    private func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win, then win
        //1.Posible win positions
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        if difficultyLevel == 3 {
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
        }
        if difficultyLevel >= 2 {
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
    
    private func checkWinCondition(for player: Player, in move: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        //First remove all nils -> then chain a filter the current player's moves
        let playerMoves = moves.compactMap { $0 }.filter{$0.player == player}
        //Get the position/index of each of the payer's moves
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        //Iterate over the winPattern and check if the current moves have a win condition
        for pattern in winPattern where pattern.isSubset(of: playerPositions) {return true}
        
        return false
    }
    
    private func checkForDraw(in moves: [Move?]) -> Bool {
        //CompactMap will remove the nils to check the count of moves, if = 9 then thats the max and is a drawn
        return moves.compactMap{ $0 }.count == 9
    }
    
    private func increaseCounter(for player: Player) {
        if player == .computer{
            scores.computer += 1
            computerScore = "\(scores.computer)"
        }else if player == .human{
            scores.human += 1
            humanScore = "\(scores.human)"
        }
    }
    
    private func resetCounter() {
        scores.computer = 0
        scores.human = 0
        humanScore = "0"
        computerScore = "0"
    }
    
}
