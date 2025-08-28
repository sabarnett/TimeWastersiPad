//
//  ContentView.swift
//  Minesweeper
//
//  Created by Paul Hudson on 03/08/2024.
//  Modified/extended by Steve Barnett - 2025
//

import SwiftUI
import AVKit
import SharedComponents

enum GameState {
    case waiting, playing, won, lost
}

public struct MinesweeperView: View {

    @AppStorage(Constants.minePlaySounds) private var minePlaySounds = true
    @AppStorage(Constants.mineGameDifficulty) private var gameDifficullty: GameDifficulty = .beginner

    @State private var game = MinesweeperGame()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var ticking: AVAudioPlayer!
    @State private var showGamePlay: Bool = false
    @State private var showLeaderBoard: Bool = false

    private var tickingURL: URL { soundFile(named: "ticking") }
    private var explosionURL: URL { soundFile(named: "explosion") }
    private var fanfareURL: URL { soundFile(named: "winner") }
    private var gameData: Game

    private var gameOverMessage: String {
        game.isWon ? "You win!" : "Bad Luck!"
    }

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                gameStatusDisplay

                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                    ForEach(0..<game.rows.count, id: \.self) { row in
                        GridRow {
                            ForEach(game.rows[row]) { square in
                                SquareView(square: square)
                                    .onTapGesture {
                                        game.select(square)
                                    }
                                    .onLongPressGesture {
                                        game.flag(square)
                                    }
                            }
                        }
                    }
                }
                .font(.largeTitle)
                .onAppear(perform: game.createGrid)
                .clipShape(.rect(cornerRadius: 6))
                .padding([.horizontal, .bottom])
                .opacity(game.isWaiting || game.isPlaying ? 1 : 0.5)

                Spacer()
            }
            .disabled(game.isWon || game.isLost)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        ticking?.stop()
                        showGamePlay.toggle()
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                    .help("Show the game play")

                    Button(action: {
                        ticking?.stop()
                        showLeaderBoard.toggle()
                    }, label: {
                        Image(systemName: "trophy.circle")
                    })
                    .help("Show the leader board")
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        toggleSounds()
                    }, label: {
                        Image(systemName: minePlaySounds ? "speaker.slash" : "speaker")
                    })
                    .help("Toggle sounds")
                }
            }

            if game.isWon || game.isLost {
                GameOverView(message: gameOverMessage) {
                    withAnimation {
                        resetGame()
                    }
                }
            }
        }
        .onChange(of: game.gameState) {
            switch game.gameState {
            case .playing:
                playSound(tickingURL, repeating: true)
            case .won:
                playSound(fanfareURL, repeating: false)
            case .lost:
                playSound(explosionURL, repeating: false)
            case .waiting:
                break
            }
        }
        .onChange(of: gameDifficullty) {
            game.reset()
        }
        .onReceive(timer) { _ in
            if showGamePlay || showLeaderBoard { return }
            guard game.isPlaying else { return }
            guard game.secondsElapsed < 999 else { return }
            game.secondsElapsed += 1
        }
        .onAppear {
            playSound(tickingURL, repeating: true)
        }
        .onDisappear {
            resetGame()
            ticking?.stop()
        }

        .sheet(isPresented: $showGamePlay, onDismiss: {
            if minePlaySounds {
                playSound(tickingURL, repeating: true)
            }
        }, content: {
            GamePlayView(game: gameData.gameDefinition)
        })

        .sheet(isPresented: $showLeaderBoard, onDismiss: {
            if minePlaySounds {
                playSound(tickingURL, repeating: true)
            }
        }, content: {
            LeaderBoardView(leaderBoard: game.leaderBoard,
                                 initialTab: game.mineGameDifficulty)
        })
    }

    /// Displays the current selected bomb count and the number of seconds elapsed. It also
    /// has a button in betweenthe two scores that allows the user to restart the game. It sits
    /// above the game play area, in the middle. Ther may be buttons to the right and
    /// left. These are produced by the toggleButtons function.
    private var gameStatusDisplay: some View {
        HStack(spacing: 0) {
            Text(game.minesFound.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)

            Button(action: resetGame) {
                Text(game.statusEmoji)
                    .padding(.horizontal, 6)
                    .background(.gray.opacity(0.5).gradient)
            }
            .onHover { hovering in
                game.isHoveringOverRestart = hovering
            }
            .buttonStyle(.plain)

            Text(game.secondsElapsed.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
        }
        .monospacedDigit()
        .font(.largeTitle)
        .background(.black)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.top)
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    private func toggleSounds() {
        minePlaySounds.toggle()
        if minePlaySounds {
            playSound(tickingURL, repeating: true)
        } else {
            ticking.stop()
        }
    }

    // Reset the game to unplayed state and restart the sounds.
    private func resetGame() {
        game.reset()
        playSound(tickingURL, repeating: true)
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: MinesweeperGame.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard minePlaySounds else { return }
        if ticking != nil { ticking.stop() }

        ticking = try? AVAudioPlayer(contentsOf: url)
        if ticking != nil {
            ticking.numberOfLoops = repeating ? -1 : 0
            self.ticking.play()
        }
    }
}

#Preview {
    MinesweeperView(gameData: Game.minesweeper)
}
