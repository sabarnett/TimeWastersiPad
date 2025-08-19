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
                topBarAndButtons.padding(8)
                Spacer()

                HStack {
                    Spacer()
                    GameGrid(model: model).frame(width: 380)
                    Spacer()
                    ScoreView(model: model).frame(maxWidth: 200)
                }

                Text(model.messages)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .disabled(model.gameState != .active)

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
//        .frame(width: 580)
    }

    var topBarAndButtons: some View {
        HStack {
            Button(action: {
                model.showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
            })
            .buttonStyle(.plain)
            .help("Show game rules")

            Spacer()

            Button(action: {
                model.resetGame()
            }, label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
            })
            .buttonStyle(.plain)
            .help("Reset the game")

            Button(action: {
                model.toggleSounds()
            }, label: {
                Image(systemName: model.speakerIcon)
            })
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    TicTacToeView(gameData: Game.ticTacToe)
}
