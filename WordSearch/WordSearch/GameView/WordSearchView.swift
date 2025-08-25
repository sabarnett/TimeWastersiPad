//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct WordSearchView: View {
    @State private var gameData: Game

    @State private var game: WordSearchViewModel = .init()
    @State private var showGamePlay: Bool = false
    @State private var showLeaderBoard: Bool = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public init(gameData: Game) {
        self.gameData = gameData
    }

    var viewWidth: CGFloat {
        (Constants.tileSize + 2) * CGFloat(Constants.tileCountPerRow)
        + Constants.wordListWidth
        + 32.0
    }

    public var body: some View {
        ZStack {
            // Game board
            VStack {
                gameStatusDisplay

                HStack(spacing: 8) {
                    ZStack {
                        GameBoardView(game: game)
                        MatchedWordsView(game: game)
                    }
                    .frame(width: (Constants.tileSize + 2) * CGFloat(Constants.tileCountPerRow))

                    TargetWordsListView(game: game)
                }
                .padding([.leading, .trailing, .bottom])
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
                            showGamePlay.toggle()
                        }, label: {
                            Image(systemName: "questionmark.circle.fill")
                        })
                        .help("Show the game play")

                        Button(action: {
                            showLeaderBoard.toggle()
                        }, label: {
                            Image(systemName: "trophy.circle.fill")
                        })
                        .help("Show the leader board")
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button(action: {
                            game.allowHints()
                        }, label: {
                            Image(systemName: game.hintsIcon)
                        })
                        .help("Allow hints")

                        Button(action: {
                            game.newGame()
                        }, label: {
                            Image(systemName: "arrow.uturn.left.circle.fill")
                        })
                        .help("Start a new game")

                        Button(action: {
                            game.toggleSounds()
                        }, label: {
                            Image(systemName: game.speakerIcon)
                        })
                        .help("Toggle sound effects")
                    }
                }
            }
            .sheet(isPresented: $showGamePlay) {
                GamePlayView(game: gameData.gameDefinition)
            }
            .sheet(isPresented: $showLeaderBoard) {
                LeaderBoardView(leaderBoard: game.leaderBoard,
                                initialTab: game.gameDifficulty)
            }
            .onReceive(timer) { _ in
                if showGamePlay || showLeaderBoard { return }
                guard game.gameState == .playing else { return }
                guard game.secondsElapsed < 9999 else { return }
                game.secondsElapsed += 1
            }
            .onAppear {
                game.playBackgroundSound()
            }
            .onDisappear {
                game.stopSounds()
            }
            // TODO: Why is this code here???
//            .overlay(
//                KeyEventHandlingView { event in
//                    handleKeyPress(event)
//                }
//                .frame(width: 0, height: 0)  // Invisible but captures keyboard input
//            )
            // Game over view
            if game.gameState == .endOfGame {
                let _ = game.stopSounds()
                GameOverView {
                    game.newGame()
                    game.playBackgroundSound()
                }
            }

        }
        .frame(width: viewWidth)
    }

//    private func handleKeyPress(_ key: NSEvent) {
//        guard let char = key.characters?.first else { return }
//        game.hilightLetter(letter: char)
//    }

    /// Format the number of seconds. We have to do it this way because we have
    /// four digits and do not want the separating comma.
    ///
    /// - Parameter seconds: The number of seconds to format
    /// - Returns: A string containing the four digit seconds count including leading zeros.
    private func secondsFormatted(seconds: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.groupingSeparator = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 4

        return formatter.string(from: NSNumber(value: seconds)) ?? ""
    }

    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay: some View {
        HStack(spacing: 0) {
            Text(secondsFormatted(seconds: game.secondsElapsed))
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
    WordSearchView(gameData: Game.wordSearch)
}
