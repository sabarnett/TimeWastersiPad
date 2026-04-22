//
// -----------------------------------------
// Original project: 2048
// Original package: 2048
// Created on: 13/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct Game2048GameView: View {
    @State private var model = Game2048Model()
    @State private var showInstructions = false

    // Gesture tracking
    @GestureState private var dragTranslation: CGSize = .zero

    @State public var gameData: Game

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        GeometryReader { geo in
            let boardSize = min(geo.size.width * 0.62, geo.size.height * 0.72)

            ZStack {
                HStack(spacing: 40) {
                    // Left panel
                    ScorePanel(model: model, performMove: performMove)
                        .frame(width: 240)
                        .padding(.vertical, 48)

                    // Board
                    ZStack {
                        BoardView(model: model, boardSize: boardSize)
                            .gesture(swipeGesture)
                    }
                }
                .padding(.horizontal, 48)
                .frame(width: geo.size.width, height: geo.size.height)

                if model.gameState != .playing {
                    GameOverView(message: model.gameOverMessage,
                                 subMessage: model.gameOverSubMessage) {
                        withAnimation {
                            model.newGame()
                        }
                    }
                }
            }
            .task { model.newGame() }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        model.showGamePlay.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                    .help("Show game rules")

                    Button(action: {
                        model.showLeaderBoard = true
                    }, label: {
                        Image(systemName: "trophy.circle")
                    })
                    .help("Show the leader board")
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
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
            .sheet(isPresented: $model.showGamePlay) {
                GamePlayView(game: gameData.gameDefinition)
            }
            .sheet(isPresented: $model.showLeaderBoard) {
                LeaderBoardView(leaderBoard: model.leaderBoard,
                                initialTab: .four)
            }
        }
    }

    // MARK: - Swipe Gesture

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 40)
            .onEnded { value in
                let h = value.translation.width
                let v = value.translation.height
                if abs(h) > abs(v) {
                    performMove(h > 0 ? .right : .left)
                } else {
                    performMove(v > 0 ? .down : .up)
                }
            }
    }

    private func performMove(_ direction: MoveDirection) {
        withAnimation(.spring(response: 0.18, dampingFraction: 0.85)) {
            model.move(direction)
        }
    }
}

#Preview {
    Game2048GameView(gameData: Game.game2048)
}

