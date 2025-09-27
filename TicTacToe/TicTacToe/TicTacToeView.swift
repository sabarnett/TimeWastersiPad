//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 27/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct TicTacToeView: View {

    @State public var gameData: Game
    @StateObject var model = TicTacToeGameModel()

    var gameOverMessage: String {
        switch model.gameState {
        case .playerWin:
            return "You win!"
        case .computerWin:
            return "I win this time"
        case .draw:
            return "It's a draw!"
        case .active:
            return "Game On!"
        }
    }

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    GeometryReader { proxy in
                        VStack {
                            Spacer()
                            let minDimension = min(proxy.size.width, proxy.size.height)
                            let tileSize = minDimension / 4.0

                            GameGrid(model: model, tileSize: tileSize)
                            Text(model.messages)
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                    }
                    Spacer()
                    ScoreView(model: model).frame(width: 250)
                }

            }
            .disabled(model.gameState != .active)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button(action: {
                        model.showGamePlay.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                    .help("Show game rules")
                })

                ToolbarItemGroup(placement: .topBarTrailing, content: {
                    Button(action: {
                        model.resetGame()
                    }, label: {
                        Image(systemName: "arrow.uturn.left.circle")
                    })
                    .help("Reset the game")

                    Button(action: {
                        model.toggleSounds()
                    }, label: {
                        Image(systemName: model.speakerIcon)
                    })
                    .help("Toggle sound effects")
                })
            }

            if model.gameState != .active {
                GameOverView(message: gameOverMessage) {
                    withAnimation {
                        model.newGame()
                    }
                }
            }
        }
        .toast(toastMessage: $model.notifyMessage)
        .sheet(isPresented: $model.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
    }
}

#Preview {
    TicTacToeView(gameData: Game.ticTacToe)
}
