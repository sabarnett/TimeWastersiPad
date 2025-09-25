//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 18/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct OthelloView: View {

    @State public var gameData: Game
    @StateObject private var model: OthelloViewModel = OthelloViewModel()

    @State private var isGameOver: Bool = false
    @State private var showLeaderBoard: Bool = false
    @State private var columns: NavigationSplitViewVisibility = .all

    var gameOverMessage: String {
        model.gameState == .playerWin ? "😀 You win!" : "🤖 I win this time."
    }

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            NavigationSplitView(columnVisibility: $columns,
                                sidebar: {
                ScoresView(model: model)
                    .navigationBarHidden(true)
            }, detail: {
                VStack(alignment: .leading) {
                    VStack {
                        Text(model.statusMessage)
                            .font(.title)
                        GeometryReader { proxy in
                            let minSize = min(proxy.size.width, proxy.size.height)
                            let cellSize = minSize / (CGFloat(model.gameBoard.count) + 1.2)

                            GameBoardView(model: model, cellSize: cellSize)
                        }
                    }
                }
            })
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        model.showGamePlay.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                    .help("Show game rules")

                    Button(action: {
                        showLeaderBoard = true
                    }, label: {
                        Image(systemName: "trophy.circle")
                    })
                    .help("Show the leader board")
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        model.showHint()
                    }, label: {
                        Image(systemName: "signpost.right")
                    })
                    .help("Show player moves")
                    .disabled(model.gameState != .playerMove)

                    Button(action: {
                        model.newGame()
                    }, label: {
                        Image(systemName: "arrow.uturn.left.circle")
                    })
                    .help("Start a new game")

                    Button(action: {
                        model.toggleSounds()
                    }, label: {
                        Image(systemName: model.speakerIcon)
                    })
                    .help("Toggle sound effects")
                }
            }
            .disabled(isGameOver)
            .sheet(isPresented: $model.showGamePlay) {
                GamePlayView(game: gameData.gameDefinition)
            }
            .toast(toastMessage: $model.notifyMessage)

            if isGameOver {
                GameOverView(message: gameOverMessage,
                             buttonCaption: "New Game") {
                    isGameOver = false
                    model.newGame()
                }
            }
        }
        .onChange(of: model.gameState) { _, new in
            if new == .playerWin || new == .computerWin {
                isGameOver = true
            }
        }
        .sheet(isPresented: $showLeaderBoard) {
            LeaderBoardView(leaderBoard: model.leaderBoard,
                            initialTab: .player)
        }
    }
}

#Preview {
    OthelloView(gameData: Game.othello)
}
