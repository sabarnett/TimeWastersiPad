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

    let cellSize: CGFloat = 20

    var headAngle: CGFloat {
        switch game.direction {
        case .up:
            270
        case .down:
            90
        case .left:
            180
        case .right:
            0
        }
    }

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                topBarAndButtons

                ZStack {
                    ForEach(game.snake, id: \.self) { segment in

                        if game.isSnakeHead(segment) {
                            game.snakeHead()
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                                .rotationEffect(Angle(degrees: headAngle))
                                .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                                          y: CGFloat(segment.y) * cellSize + cellSize / 2)
                        } else {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: cellSize, height: cellSize)
                                .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                                          y: CGFloat(segment.y) * cellSize + cellSize / 2)
                        }
                    }

                    Image(systemName: "applelogo")
                        .scaleEffect(1.8)
                        .foregroundStyle(.red)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: CGFloat(game.food.x) * cellSize + cellSize / 2,
                                  y: CGFloat(game.food.y) * cellSize + cellSize / 2)

                    if pause {
                        Image(systemName: "pause.circle.fill")
                            .scaleEffect(4)
                            .zIndex(1)
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: cellSize * CGFloat(game.gridSize), height: cellSize * CGFloat(game.gridSize))
                .background(Color.black)
                .border(Color.red, width: 1)
            }
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
            .disabled(game.isGameOver)

            if game.isGameOver {
                GameOverView(message: "Bad luck") {
                    withAnimation {
                        restartGame()
                    }
                }
            }
        }
        .onAppear {
            startGameLoop()
        }
        .onDisappear {
            game.stopSounds()
            timer?.invalidate()
        }
        .frame(width: cellSize * CGFloat(game.gridSize + 2), height: cellSize * CGFloat(game.gridSize) + 80)
        .background(colorScheme == .dark ? Color.black : Color.white)

        // TODO: Find some other way to handle the keyboard
//        .overlay(
//            KeyEventHandlingView { event in
//                handleKeyPress(event)
//            }
//                .frame(width: 0, height: 0)  // Invisible but captures keyboard input
//        )
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

    // TODO: Find some other way to handle the keyboard
//    func handleKeyPress(_ event: NSEvent) {
//        switch event.keyCode {
//        case 49:    // Space bar
//            pause.toggle()
//        case 123:  // Left arrow
//            game.changeDirection(newDirection: .left)
//        case 124:  // Right arrow
//            game.changeDirection(newDirection: .right)
//        case 125:  // Down arrow
//            game.changeDirection(newDirection: .down)
//        case 126:  // Up arrow
//            game.changeDirection(newDirection: .up)
//        default:
//            break
//        }
//    }

    private func restartGame() {
        game.resetGame()
        startGameLoop()
    }
}

#Preview {
    SnakeGameView(gameData: Game.snake)
}
