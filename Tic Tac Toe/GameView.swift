//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by FGT MAC on 5/12/21.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            Spacer()
            HStack{
                Spacer()
                Text("Me")
                    .font(.system(size: 25, weight: .light, design: .default))
                Spacer()
                Text(viewModel.humanScore)
                    .font(.system(size: 25, weight: .bold, design: .default))
                Text("-")
                Text(viewModel.computerScore)
                    .font(.system(size: 25, weight: .bold, design: .default))
                Spacer()
                Text("A.I")
                    .font(.system(size: 25, weight: .light, design: .default))
                Spacer()
            }
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            GameSquareView(proxy: geometry)
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
            
            VStack{
                Spacer()
                Picker(selection: $viewModel.difficultyLevel, label: Text("Pick Level")) {
                    Text("Easy").tag(1)
                    Text("Mid").tag(2)
                    Text("Hard").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
        }
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
        GameView()
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.blue).opacity(0.5)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
    }
}

struct PlayerIndicator: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
