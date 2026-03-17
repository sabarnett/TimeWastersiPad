//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 17/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct WonderingDigitsGameView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State public var gameData: Game
    @State private var game: WonderingDigitsGame = WonderingDigitsGame()
    @State private var showLeaderBoard = false
    @State private var showMasterCode = false

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                Text("To Do")
            }
        }
        .padding()
        .disabled(game.isGameOver)
        .task { game.restart() }
        .onAppear { game.playBackgroundSound() }
        .onDisappear { game.stopSounds() }
        .background(colorScheme == .dark ? Color.black : Color.white)

        .sheet(isPresented: $game.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .sheet(isPresented: $showLeaderBoard) {
            //                LeaderBoardView(leaderBoard: game.leaderBoard,
            //                                initialTab: game.cmGameLevel)
        }
        .sheet(isPresented: $showMasterCode, onDismiss: {
            withAnimation { game.restart() }
        }) {
            //                CodeRevealView(pegs: game.masterCode.pegs, attempts: game.attempts.count)
            //                    .padding()
        }

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
            let str = AttributedString(localized: "You won in ^[\(game.attemptsCount) move](inflect: true)")
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
    WonderingDigitsGameView(gameData: Game.snake)
}


