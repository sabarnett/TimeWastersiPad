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

    public var body: some View {
        ZStack {
            VStack {
                gameStatusDisplay

                HStack(spacing: 8) {
                    GeometryReader { proxy in
                        HStack {
                            Spacer()
                            GameBoardView(game: game,
                                          cellSize: cellSize(proxy: proxy),
                                          fontSize: fontSize(proxy: proxy))
                            Spacer()
                        }
                    }

                    TargetWordsListView(game: game)
                        .frame(minWidth: 200)
                }
                .padding([.leading, .trailing, .bottom])
                .toolbar {
                    topBarLeadingToolbar
                    topBarTrailing
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
            if game.gameState == .endOfGame {
                // swiftlint:disable:next redundant_discardable_let
                let _ = game.stopSounds()
                GameOverView {
                    game.newGame()
                    game.playBackgroundSound()
                }
            }

        }
    }

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

    /// Defines the content of the toolbar that is aligned to the top/leading.
    @ToolbarContentBuilder
    private var topBarLeadingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button(action: {
                showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle")
            })
            .help("Show the game play")

            Button(action: {
                showLeaderBoard.toggle()
            }, label: {
                Image(systemName: "trophy.circle")
            })
            .help("Show the leader board")
        }
    }

    /// Defines the content of the toolbar that is aligned to the top/trailing
    @ToolbarContentBuilder
    private var topBarTrailing: some ToolbarContent {
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
                Image(systemName: "arrow.uturn.left.circle")
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
    
    /// Calculates the sie of the font to use on the individual cells. It is based on
    /// the cell size.
    /// - Parameter proxy: The proxy from the GeometryReader that defines the
    /// amount of space available for the view
    /// - Returns: The font size to use for each letter button.
    private func fontSize(proxy: GeometryProxy) -> CGFloat {
        cellSize(proxy: proxy) * 0.5
    }
    
    /// Calculates the size of the button to create for each letter in the grid.
    /// - Parameter proxy: The proxy from the GeometryReader that defines the
    /// amount of space available for the view
    /// - Returns: The size to use for each cell based on the amount of available space.
    /// We allow for a gap equivalent to one cell around the game board.
    private func cellSize(proxy: GeometryProxy) -> CGFloat {
        let minDimension = min(proxy.size.width, proxy.size.height)
        return minDimension / CGFloat(game.gameBoard.count + 1)
    }
}

#Preview {
    WordSearchView(gameData: Game.wordSearch)
}
