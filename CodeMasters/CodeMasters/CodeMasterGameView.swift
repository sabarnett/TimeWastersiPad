//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 13/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct CodeMasterGameView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State public var gameData: Game
    @State private var selection: Int = 0
    @StateObject private var game: CodeMasterGame = CodeMasterGame()
    @State private var showLeaderBoard = false
    @State private var showMasterCode = false

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                Group {
                    CodeView(code: game.masterCode) {
                        attemptsCount()
                    }

                    if !game.isGameOver {
                        CodeView(code: game.guess, selection: $selection) {
                            if !game.isGameOver {
                                guessButton()
                            }
                        }
                        .transition(.asymmetric(insertion: .move(edge: .top), removal: .opacity))
                    }
                    Divider()

                    ScrollView {
                        ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                            if game.attempts.count > index {
                                let code = game.attempts[index]
                                CodeView(code: code) {
                                    if let matches = code.matches {
                                        MatchMarkers(matches: matches)
                                    }
                                }
                                .transition(AnyTransition.asymmetric(
                                    insertion: game.isGameOver ? .opacity : .move(edge: .top),
                                    removal: .move(edge: .trailing)
                                ))
                            }
                        }
                    }
                }
                .frame(maxWidth: 100.0 * CGFloat(game.masterCode.pegs.count))

                if !game.isGameOver {
                    PegChooser(pegChoices: game.pegChoices) { choice in
                        game.changeGuessPeg(at: selection, to: choice)
                        game.playKeyboardSound()
                        selection = (selection + 1) % game.masterCode.pegs.count
                    }
                    .frame(maxWidth: 100.0 * CGFloat(game.pegChoices.count))
                    .transition(AnyTransition.offset(x: 0, y: 200))
                }
            }
            .padding()

            .disabled(game.isGameOver)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    showGamePlayButton()
                    showLeaderBoardButton()
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    revealCodeButton()
                    restartGameButton()
                    toggleSoundButton()
                }
            }

            if game.isGameOver {
                let str = AttributedString(localized: "You won in ^[\(game.attempts.count) move](inflect: true)")
                let subMessage = String(str.characters)

                GameOverView(message: "You completed the puzzle!",
                             subMessage: subMessage) {
                    withAnimation {
                        game.stopSounds()
                        game.restart()
                    }
                }
            }
        }
        .onAppear {
            game.playBackgroundSound()
        }
        .onDisappear {
            game.stopSounds()
        }
        .background(colorScheme == .dark ? Color.black : Color.white)

        .sheet(isPresented: $game.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .sheet(isPresented: $showLeaderBoard) {
            LeaderBoardView(leaderBoard: game.leaderBoard,
                            initialTab: game.cmGameLevel)
        }
        .sheet(isPresented: $showMasterCode, onDismiss: {
            withAnimation { game.restart() }
        }) {
            CodeRevealView(pegs: game.masterCode.pegs, attempts: game.attempts.count)
                .padding()
        }
    }

    fileprivate func attemptsCount() -> some View {
        return Text(game.attempts.count.formatted(.number.precision(.integerLength(3))))
            .foregroundStyle(.red.gradient)
            .font(.system(size: 80))
            .bold()
            .minimumScaleFactor(0.1)
    }

    fileprivate func guessButton() -> some View {
        return Button("Guess") {
            withAnimation {
                game.playDingSound()
                game.attemptGuess()
                selection = 0
            }
        }
        .tint(.green)
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
        .disabled(!game.canGuess)
    }

    // MARK: - Toolbar Buttons
    fileprivate func showGamePlayButton() -> some View {
        return Button(action: {
            game.showGamePlay = true
        }, label: {
            Image(systemName: "questionmark.circle")
        })
        .help("Show game rules")
    }

    fileprivate func showLeaderBoardButton() -> some View {
        return Button(action: {
            showLeaderBoard = true
        }, label: {
            Image(systemName: "trophy.circle")
        })
        .help("Show the leader board")
    }

    fileprivate func revealCodeButton() -> some View {
        return Button(action: {
            withAnimation {
                game.stopSounds()
                showMasterCode = true
            }
        }, label: {
            Image(systemName: "eye.circle")
        })
        .help("Reveal the code")
    }

    fileprivate func restartGameButton() -> some View {
        return Button(action: {
            game.restart()
        }, label: {
            Image(systemName: "arrow.uturn.left.circle")
        })
        .help("Restart the game")
    }

    fileprivate func toggleSoundButton() -> some View {
        return Button(action: {
            game.toggleSounds()
        }, label: {
            Image(systemName: game.speakerIcon)
        })
        .help("Toggle sound effects")
    }

}

#Preview {
    CodeMasterGameView(gameData: Game.snake)
}
