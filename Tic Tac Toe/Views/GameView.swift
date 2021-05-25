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
                    Text("Single Mode").tag(0)
                    Text("Multi Players Mode").tag(1)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                HStack{
                    
                    Spacer()
                    Text(viewModel.playingMode == 0 ? "Me" : "Player 1")
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
                Button {
                    viewModel.isSoundEnable.toggle()
                } label: {
                    Image(systemName: viewModel.isSoundEnable ? "speaker.wave.3" : "speaker.slash")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                
            }
            VStack{
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { index in
                        ZStack{
                            GameSquareView(proxy: geometry, viewModel: viewModel, index: index)
                            PlayerIndicator(systemImageName: viewModel.moves[index]?.indicator ?? "", viewModel: viewModel, index: index)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: index)
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
                    //                    Text("Auto").tag(3) //TODO: Use to automatically increse level after 5-10 turns without reseting counter (Logic Not created yet)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
        }
        .background(
            Image("wallpaper3")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        )
    }
}

// MARK: - GameSquareView
struct GameSquareView: View {
    var proxy: GeometryProxy
    var viewModel: GameViewModel
    var index: Int
    var body: some View {
        Circle()
            .foregroundColor(viewModel.circleColor).opacity(0.3)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
            .scaleEffect(viewModel.moves[index] == nil ? 1.0 : 0.2)
            .animation(.default)
    }
}

// MARK: - PlayerIndicator
struct PlayerIndicator: View {
    var systemImageName: String
    var viewModel: GameViewModel
    var index: Int
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
            .rotationEffect(.degrees(viewModel.moves[index] == nil ? 0 : 180))
            .animation(.default)
    }
}


// MARK: - ContentView_Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}




