//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/18/21.
//

import SwiftUI

enum DificultyLevel: String, CaseIterable {
    case auto, easy, mid, high
}

//Final is use to prevent other classes from inheriting from this one
//ObservableObject To manage state
final class GameViewModel: ObservableObject {
    
    // MARK: - Properties
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    // MARK: - Private Properties
    private var soundPlayer = SoundsPlayer()
    private var player1Turn: Bool = true
    private var colors: [Color] = [.blue, .purple, .red]
    private var scores: (human: Int, computer: Int) =  (human: 0, computer: 0)
    private var difficultyLevel: DificultyLevel = DificultyLevel.allCases[0]
    private var haptics = UINotificationFeedbackGenerator()
    
    // MARK: - Published Properties
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisable = false
    @Published var alertItem: AlertItem?
    @Published var humanScore: String = "0"
    @Published var computerScore: String = "0"
    @Published var circleColor: Color = .blue
    @Published var playingMode: Int = 0 {
        didSet{
            resetCounter()
            resetGame()
            player1Turn = true // This preven bug where if user switch from 2player to AI the player2 might be active
        }
    }
    @Published var selectedDifficultyLevel: Int = 0 {
        didSet{
            if selectedDifficultyLevel == 0 {
                setAutoDifficulty()
            }else{
                //If user changes the difficulty level reset game
                difficultyLevel = DificultyLevel.allCases[selectedDifficultyLevel]
                updateColor()
            }
            resetCounter()
            resetGame()
        }
    }
    @Published var isSoundEnable: Bool = true
    @Published var playAnimation = false
    @Published var animationName: String = "won-confetti"
    
    // MARK: - Methods
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position){ return }
        
        if player1Turn{
            playerMove(for: position, player: .player1)
            soundPlayer.playSound(sound: "player1", type: "wav", isSoundEnable: isSoundEnable)
            haptics.notificationOccurred(.success)
            if playingMode == 1 {
                player1Turn.toggle()
            }
        }else{
            playerMove(for: position, player: .player2)
            player1Turn.toggle()
            soundPlayer.playSound(sound: "player2", type: "wav", isSoundEnable: isSoundEnable)
            haptics.notificationOccurred(.success)
        }
    }
    
    func resetGame() {
        moves =  Array(repeating: nil, count: 9)
    }
    
    // MARK: - Private Methods
    private func setAutoDifficulty() {
        switch scores.human {
        case 5..<10:
            difficultyLevel = .mid
            updateColor()
            self.playAnimation.toggle()
        case 10 ..< 1000:
            difficultyLevel = .high
            updateColor()
            self.playAnimation.toggle()
        default:
            difficultyLevel = .easy
            updateColor()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.00) {
            self.playAnimation = false
        }
    }
    
    private func playerMove(for position: Int, player: Player) {
        //1.User move
        moves[position] = Move(player: player, boardIndex: position)
        
        //Check for win conditions
        if checkWinCondition(for: player, in: moves){
            if player == .player1 {
                alertItem =  AlertContext.player1
            }else{
                alertItem =  AlertContext.player2
            }
            increaseCounter(for: player)
            
            DispatchQueue.main.async { [self] in
                self.soundPlayer.playSound(sound: "winner", type: "wav", isSoundEnable: isSoundEnable)
                haptics.notificationOccurred(.success)
            }
            return
        }
        
        if checkForDraw(in: moves){
            alertItem =  AlertContext.draw
            DispatchQueue.main.async { [self] in
                self.soundPlayer.playSound(sound: "lose", type: "wav", isSoundEnable: isSoundEnable)
                haptics.notificationOccurred(.warning)
            }
            return
        }
        
        if playingMode == 0 {
            computerMove(for: position)
        }
    }
    
    private func computerMove(for position: Int) {
        
        isGameboardDisable = true
        //2.After a half sec delay computer will make a move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            isGameboardDisable = false
            //Check for win conditions
            if checkWinCondition(for: .computer, in: moves){
                alertItem =  AlertContext.computer
                increaseCounter(for: .computer)
                self.soundPlayer.playSound(sound: "lose", type: "wav", isSoundEnable: isSoundEnable)
                haptics.notificationOccurred(.warning)
                return
            }
            
            if checkForDraw(in: moves){
                alertItem =  AlertContext.draw
                self.soundPlayer.playSound(sound: "lose", type: "wav", isSoundEnable: isSoundEnable)
                haptics.notificationOccurred(.warning)
                return
            }
            soundPlayer.playSound(sound: "player2", type: "wav", isSoundEnable: isSoundEnable)
            haptics.notificationOccurred(.success)
        }
    }
    
    private func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    private func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //If AI can win, then win
        //1.Posible win positions
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        if difficultyLevel == .high {
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
        if difficultyLevel == .mid || difficultyLevel == .high {
            //If AI can't win, then block(Similar to above but this time we check for human moves to block
            
            //1.Remove nils from all positions and then filter to get only computer positions
            let humanMoves = moves.compactMap { $0 }.filter{$0.player == .player1}
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
        if player == .player1 {
            scores.human += 1
            humanScore = "\(scores.human)"
        }else{
            scores.computer += 1
            computerScore = "\(scores.computer)"
        }
        
        if selectedDifficultyLevel == 0 {//If difficulty level is set to auto
            setAutoDifficulty()
        }
    }
    
    private func resetCounter() {
        scores.computer = 0
        scores.human = 0
        humanScore = "0"
        computerScore = "0"
    }
    
    private func updateColor(){
        switch difficultyLevel {
        case .mid:
            circleColor = colors[1]
        case .high:
            circleColor = colors[2]
        default:
            circleColor = colors[0]
        }
    }
    
}
