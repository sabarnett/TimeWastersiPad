//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 20/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct MatchedPairsView: View {
    @State public var gameData: Game
    @State var model: MatchedPairsGameModel

    @State private var showGamePlay: Bool = false
    @State private var showLeaderBoard: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var windowWidth: Double {
        (87.0 * Double(model.columns)) + 16.0
    }

    public init(gameData: Game) {
        self.gameData = gameData
        self.model = MatchedPairsGameModel()
    }

    public var body: some View {
        ZStack {
            VStack {
                ZStack {
                    toggleButtons
                    gameStatusDisplay
                }
                GameGridView(model: model)
                    .padding()
                    .disabled(model.gameState != .playing)
            }

            if model.gameState == .gameOver {
                GameOverView {
                    withAnimation {
                        model.newGame()
                    }
                }
            }
        }
        .sheet(isPresented: $showGamePlay, onDismiss: {
            if model.playSounds {
                model.playBackgroundSound()
            }
        }, content: {
            GamePlayView(game: gameData.gameDefinition)
        })

        .sheet(isPresented: $showLeaderBoard, onDismiss: {
            if model.playSounds {
                model.playBackgroundSound()
            }
        }, content: {
            LeaderBoardView(leaderBoard: model.leaderBoard,
                            initialTab: model.gameDifficulty)
        })

        .onReceive(timer) { _ in
            if showGamePlay || showLeaderBoard { return }
            guard model.gameState == .playing else { return }
            guard model.time < 999 else { return }
            model.time += 1
        }

        .onChange(of: model.gameState) { _, newState in
            if newState == .gameOver {
                model.stopSounds()
            }
        }

        .frame(width: windowWidth)
    }

    /// Handles any toggle buttons to display in the scores area. We do these separately to
    /// the score display because we want the scores to be centered regardless of how many
    /// buttons we have in the buttons area.
    private var toggleButtons: some View {
        HStack {
            Button(action: {
                model.stopSounds()
                showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Show the game play")

            Button(action: {
                model.stopSounds()
                showLeaderBoard.toggle()
            }, label: {
                Image(systemName: "trophy.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Show the leader board")

            Spacer()

            Button(action: {
                model.newGame()
            }, label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .scaleEffect(2)
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Start a new game")

            Button(action: {
                model.toggleSounds()
            }, label: {
                Image(systemName: model.speakerIcon)
                    .scaleEffect(2)
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Toggle sounds")

        }
        .padding([.horizontal, .top])
    }

    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay: some View {
        HStack(spacing: 0) {
            // Matched items
            Text(model.moves.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
                .help("Number of moves so far.")

            Text("♦️")

            // Seconds elapsed
            Text(model.time.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
                .help("Time taken, so far.")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .background(.black)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.top)
    }
}

#Preview {
    MatchedPairsView(gameData: Game.matchedPairs)
}
