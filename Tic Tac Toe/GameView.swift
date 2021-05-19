//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/12/21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Spacer()
            VStack{
                Picker(selection: $viewModel.playingMode, label: Text("Playing Mode")) {
                    Text("A.I Mode").tag(0)
                    Text("2 Players Mode").tag(1)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
            
            HStack{
                
                Spacer()
                Text("Player 1")
                    .font(.system(size: 25, weight: .light, design: .default))
                Spacer()
                Text(viewModel.humanScore)
                    .font(.system(size: 25, weight: .bold, design: .default))
                Text("-")
                Text(viewModel.computerScore)
                    .font(.system(size: 25, weight: .bold, design: .default))
                Spacer()
                Text(viewModel.playingMode == 0 ? "A.I" : "Player 2")
                    .font(.system(size: 25, weight: .light, design: .default))
                Spacer()
            }
            }
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            GameSquareView(proxy: geometry, color: viewModel.circleColor)
                            PlayerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for:i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisable)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.butonTitle, action: { viewModel.resetGame() }))
            })
            //Place Google ads here
            VStack{
                Spacer()
                Picker(selection: $viewModel.difficultyLevel, label: Text("Pick Level")) {
                    Text("Easy").tag(0)
                    Text("Mid").tag(1)
                    Text("Hard").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
        }
    }
}

// MARK: - Player
enum Player {
    case player1, computer, player2
}


// MARK: - Move
struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String{
        //If is player 1 = X computer or player 2 = O
        return player == .player1 ? "xmark" : "circle"
    }
}

// MARK: - GameSquareView
struct GameSquareView: View {
    var proxy: GeometryProxy
    var color: Color
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

// MARK: - PlayerIndicator
struct PlayerIndicator: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}


// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}




