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
                    Image(systemName: "person.fill").tag(0)
                    Image(systemName: "person.2.fill").tag(1)
                    
                }
                .pickerStyle(SegmentedPickerStyle())
                HStack(spacing: 15){
                    HStack{
                        VStack{
                            Text(viewModel.playingMode == 0 ? "Me" : "Player 1").fontWeight(.bold)
                            Text(viewModel.humanScore).fontWeight(.bold).font(.system(size: 22))
                        }.padding()
                        .frame(width: (UIScreen.main.bounds.width - 45 ) / 2)
                        .background(Color.blue)
                        .cornerRadius(15)
                    }
                    Spacer(minLength: 0)
                    
                    HStack{
                        VStack{
                            Text(viewModel.playingMode == 0 ? "A.I" : "Player 2").fontWeight(.bold)
                            Text(viewModel.computerScore).fontWeight(.bold).font(.system(size: 22))
                        }.padding()
                        .frame(width: (UIScreen.main.bounds.width - 45 ) / 2)
                        .background(Color.pink)
                        .cornerRadius(15)
                    }
                }
                Spacer(minLength: 0)
                
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




