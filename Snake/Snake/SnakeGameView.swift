//
// -----------------------------------------
// Original project: SnakeGPT
// Original package: SnakeGPT
// Created on: 04/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//
// Developer note: The .position modifier calculates the center point of the
// rectangles we are using to build the display. So, everywhere we calculate
// a position, we need to add half a cell size to keep the rectangle on the
// playing area.
//

import SwiftUI
import SharedComponents

public struct SnakeGameView: View {

    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(Constants.snakeGameSpeed) private var snakeGameSpeed: SnakeGameSpeed = .medium

    @State public var gameData: Game
    @State private var game = SnakeGame()
    @State private var timer: Timer?
    @State private var pause: Bool = true
    @State private var showLeaderBoard: Bool = false
    @FocusState private var hasFocus: Bool

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                topBarAndButtons

                GeometryReader { proxy in
                    let maxWidth = proxy.size.height > proxy.size.width
                    ? proxy.size.width
                    : proxy.size.height
                    let cellSize = maxWidth / CGFloat(game.gridSize + 3)

                    HStack {
                        Spacer()
                        SnakeGameBoard(game: game,
                                       cellSize: cellSize,
                                       pause: pause)
                        .frame(width: cellSize * CGFloat(game.gridSize),
                               height: cellSize * CGFloat(game.gridSize))
                        .background(Color.black)
                        .border(Color.red, width: 1)
                        Spacer()
                    }
                }
            }
            .disabled(game.isGameOver)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        pause = true
                        game.showGamePlay = true
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                    .help("Show game rules")

                    Button(action: {
                        pause = true
                        showLeaderBoard = true
                    }, label: {
                        Image(systemName: "trophy.circle")
                    })
                    .help("Show the leader board")
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        restartGame()
                    }, label: {
                        Image(systemName: "arrow.uturn.left.circle")
                    })
                    .help("Restart the game")

                    Button(action: {
                        game.toggleSounds()
                    }, label: {
                        Image(systemName: game.speakerIcon)
                    })
                    .help("Toggle sound effects")
                }
            }

            if game.isGameOver {
                GameOverView(message: "Bad luck") {
                    withAnimation {
                        restartGame()
                    }
                }
            }
            Color.clear
                .overlay(alignment: .bottomTrailing) {
                    GamePlayButtons(isPaused: $pause) { key in
                        handleKeyPress(key)
                    }
                    .frame(width: 250, height: 250)
                }
                .overlay(alignment: .bottomLeading) {
                    GamePlayButtons(isPaused: $pause) { key in
                        handleKeyPress(key)
                    }
                    .frame(width: 250, height: 250)
                }
        }
        .onAppear {
            startGameLoop()
            hasFocus = true
        }
        .onDisappear {
            game.stopSounds()
            timer?.invalidate()
        }
        .background(colorScheme == .dark ? Color.black : Color.white)

        // This is a fix for running the game on the Mac. It allows
        // the player to use the keyboard to control the game. The
        // arrow keys switch direction and the space bar acts as a
        // pause/resume key.
        .focusable()
        .focused($hasFocus)
        .onKeyPress(action: { key in
            handleKeyPress(key.key)
            return .handled
        })
        .sheet(isPresented: $game.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .sheet(isPresented: $showLeaderBoard) {
            LeaderBoardView(leaderBoard: game.leaderBoard,
                            initialTab: game.snakeGameSize)
        }
    }

    var topBarAndButtons: some View {
        HStack {
            Spacer()

            Text(game.snake.count.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
            Spacer()
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }

    func startGameLoop() {
        pause = true
        game.playBackgroundSound()
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: snakeGameSpeed.speed,
            repeats: true
        ) { _ in
            Task {
                await snakeMove()
            }
        }
    }

    @MainActor func snakeMove() {
        guard pause == false else { return }
        game.moveSnake()
    }

    // Handle a keyboard press on the Mac
    func handleKeyPress(_ key: KeyEquivalent) {
        switch key {
        case .space:
            pause.toggle()
        case .leftArrow:
            game.changeDirection(newDirection: .left)
        case .rightArrow:
            game.changeDirection(newDirection: .right)
        case .downArrow:
            game.changeDirection(newDirection: .down)
        case .upArrow:
            game.changeDirection(newDirection: .up)
        default:
            break
        }
    }

    private func restartGame() {
        game.resetGame()
        startGameLoop()
    }
}

#Preview {
    SnakeGameView(gameData: Game.snake)
}
