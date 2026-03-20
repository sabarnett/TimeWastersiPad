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
import Combine

public struct WanderingDigitsGameView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State public var gameData: Game
    @State private var game: WanderingDigitsGame = WanderingDigitsGame()
    @State private var showLeaderBoard = false
    @State private var showSolution = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                gameStatusDisplay
                Spacer()

                GameBoardView(gameBoard: game.gameBoard,
                              checkResult: game.checkMove)

                Spacer()
            }
            .disabled(game.isGameOver)

            if game.isGameOver {
                let str = AttributedString(localized: "You won in ^[\(game.secondsElapsed) second](inflect: true) and took ^[\(game.attempts) attempt](inflect: true)")
                let subMessage = String(str.characters)

                GameOverView(message: "You restored the formula!",
                             subMessage: subMessage) {
                    withAnimation {
                        game.stopSounds()
                        game.restart()
                    }
                }
            }

        }
        .padding()
        .task { game.restart() }
        .onAppear { game.playBackgroundSound() }
        .onDisappear { game.stopSounds() }
        .background(colorScheme == .dark ? Color.black : Color.white)
        
        .onReceive(timer) { _ in
            if game.showGamePlay || showLeaderBoard { return }
            guard game.isPlaying else { return }
            guard game.secondsElapsed < 999 else { return }
            game.secondsElapsed += 1
        }

        .sheet(isPresented: $game.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .sheet(isPresented: $showLeaderBoard) {
            LeaderBoardView(leaderBoard: game.leaderBoard)
        }
        .sheet(isPresented: $showSolution, onDismiss: {
            withAnimation { game.restart() }
        }) {
            SolutionRevealView(gameBoard: game.gameBoard, attempts: 0)
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

    }

    fileprivate func valueDisplay(_ value: [String], mathOperator: String) -> some View {
        HStack {
            ForEach(value.indices, id: \.self) { index in
                Text(value[index])
                    .font(.system(size: 70))
                    .monospacedDigit()
            }
            Text(mathOperator)
                .font(.system(size: 70))
                .padding(.leading, 12)
                .monospacedDigit()
                .frame(minWidth: 60)
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
                showSolution = true
            }
        }, label: {
            Image(systemName: "eye.circle")
        })
        .help("Reveal the code")
    }

    fileprivate func restartGameButton() -> some View {
        return Button(action: {
            withAnimation {
                game.restart()
            }
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

    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay: some View {
        HStack(spacing: 0) {
            Text("Attempts:")
                .font(.callout)
            Text(game.attempts.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)

            Image(systemName: "diamond.fill")
                .font(.title3)

            Text(game.secondsElapsed.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
            Text("seconds")
                .font(.callout)
        }
        .padding(.horizontal)
        .monospacedDigit()
        .font(.largeTitle)
        .foregroundStyle(.white.gradient)
        .background(.black)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.top)
    }

}

#Preview {
    WanderingDigitsGameView(gameData: Game.snake)
}


