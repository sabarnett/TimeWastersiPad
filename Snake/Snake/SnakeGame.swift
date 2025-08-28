//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 04/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import AVKit

enum Direction {
    case up, down, left, right
}

struct Position: Equatable, Hashable {
    var x: Int
    var y: Int
}

@Observable
class SnakeGame {

    @ObservationIgnored
    @AppStorage(Constants.snakePlaySounds) var snakePlaySounds = true {
        didSet {
            updateSounds()
        }
    }

    @ObservationIgnored
    @AppStorage(Constants.snakeGameSize) var snakeGameSize: SnakeGameSize = .medium

    @ObservationIgnored
    var leaderBoard: LeaderBoard = LeaderBoard()

    var showGamePlay: Bool = false
    var snake: [Position] = []
    var food: Position = Position(x: 0, y: 0)
    var direction: Direction = .right
    var isGameOver = false
    var gridSize = 20

    init() {
        gridSize = snakeGameSize.rawValue
        snake = [Position(x: gridSize / 2, y: gridSize / 2)]
        food = Position(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
    }

    func isSnakeHead(_ cell: Position) -> Bool {
        snake[0] == cell
    }

    func moveSnake() {
        guard !isGameOver else { return }

        var newHead = snake[0]

        switch direction {
        case .up:
            newHead.y -= 1
        case .down:
            newHead.y += 1
        case .left:
            newHead.x -= 1
        case .right:
            newHead.x += 1
        }

        // Check for wall collision
        if newHead.x < 0 || newHead.x >= gridSize || newHead.y < 0 || newHead.y >= gridSize {
            isGameOver = true
            leaderBoard.addLeader(score: snake.count, forLevel: snakeGameSize)
            stopSounds()
            return
        }

        // Check for self collision
        if snake.contains(newHead) {
            isGameOver = true
            leaderBoard.addLeader(score: snake.count, forLevel: snakeGameSize)
            stopSounds()
            return
        }

        // Move snake
        snake.insert(newHead, at: 0)

        // Check for food
        if newHead == food {
            playBiteSound()
            food = Position(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
        } else {
            snake.removeLast()  // Remove the tail if no food is eaten
        }
    }

    func changeDirection(newDirection: Direction) {
        // Prevent snake from reversing direction
        if (newDirection == .up && direction != .down) ||
           (newDirection == .down && direction != .up) ||
           (newDirection == .left && direction != .right) ||
           (newDirection == .right && direction != .left) {
            direction = newDirection
        }
    }

    func resetGame() {
        gridSize = snakeGameSize.rawValue
        snake = [Position(x: gridSize / 2, y: gridSize / 2)]
        food = Position(x: Int.random(in: 0..<gridSize), y: Int.random(in: 0..<gridSize))
        direction = .right
        isGameOver = false
    }

    // MARK: - Souond functions

    private var sounds: AVAudioPlayer!
    private var bite: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var biteURL: URL { soundFile(named: "bite") }
    var speakerIcon: String = "speaker"

    /// Play the background music
    func playBackgroundSound() {
        guard snakePlaySounds else { return }
        playSound(backgroundURL, repeating: true, volume: 0.3)
    }

    /// If the background music is playing, stop it.
    func stopSounds() {
        guard snakePlaySounds else { return }
        sounds.stop()
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playBiteSound() {
        guard snakePlaySounds else { return }
        bite = try? AVAudioPlayer(contentsOf: biteURL)
        bite.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        snakePlaySounds.toggle()
    }

    private func updateSounds() {
        speakerIcon = snakePlaySounds ? "speaker.slash" : "speaker"

        if snakePlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: SnakeGame.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false, volume: Float = 1) {
        guard snakePlaySounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            if volume != 1 { sounds.volume = volume }
            self.sounds.play()
        }
    }

    // MARK: - Image assets

    // convenient for specific image
    public func snakeHead() -> Image {
        return Image("snakeHead", bundle: Bundle(for: SnakeGame.self))
    }

    // for any image located in bundle where this class has built
    public func image(named: String) -> Image {
        return Image(named, bundle: Bundle(for: SnakeGame.self))
    }
}
