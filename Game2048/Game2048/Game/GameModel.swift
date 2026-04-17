//
// -----------------------------------------
// Original project: 2048
// Original package: 2048
// Created on: 13/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI
import AVKit

@Observable
final class GameModel {
    @ObservationIgnored
    @AppStorage(Constants.playSounds) var gamePlaySounds = false {
        didSet {
            updateSounds()
        }
    }

    private(set) var tiles: [Tile] = []
    private(set) var score: Int = 0
    private(set) var bestScore: Int = 0
    private(set) var gameState: GameState = .playing
    private(set) var isAnimating: Bool = false

    private let gridSize = Constants.gameGridSize

    var showGamePlay: Bool = false
    var showLeaderBoard: Bool = false

    var speakerIcon = ""
    var sounds: AVAudioPlayer!
    var backgroundURL: URL { soundFile(named: "background") }

    init() {
        bestScore = UserDefaults.standard.integer(forKey: "bestScore2048")
        speakerIcon = gamePlaySounds ? "speaker.slash" : "speaker"
    }

    func newGame() {
        tiles = []
        score = 0
        gameState = .playing
        addRandomTile()
        addRandomTile()
    }

    // MARK: - Move

    func move(_ direction: MoveDirection) {
        guard gameState == .playing, !isAnimating else { return }

        var grid = buildGrid()
        let (newGrid, gained) = slide(grid: grid, direction: direction)

        guard newGrid != grid else { return }

        score += gained
        if score > bestScore {
            bestScore = score
            UserDefaults.standard.set(bestScore, forKey: "bestScore2048")
        }

        grid = newGrid
        rebuildTiles(from: grid)
        addRandomTile()
        checkGameState()
    }

    // MARK: - Grid Helpers

    private func buildGrid() -> [[Int]] {
        var grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        for tile in tiles {
            grid[tile.row][tile.col] = tile.value
        }
        return grid
    }

    private func rebuildTiles(from grid: [[Int]]) {
        var newTiles: [Tile] = []
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] > 0 {
                    var tile = Tile(value: grid[row][col], row: row, col: col)
                    // Mark merged tiles briefly for animation
                    if let existing = tiles.first(where: { $0.row == row && $0.col == col && $0.value == grid[row][col] }) {
                        tile = existing
                        tile.row = row
                        tile.col = col
                    }
                    newTiles.append(tile)
                }
            }
        }
        tiles = newTiles
    }

    private func addRandomTile() {
        var empty: [(Int, Int)] = []
        let grid = buildGrid()
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == 0 { empty.append((row, col)) }
            }
        }
        guard let (row, col) = empty.randomElement() else { return }
        var tile = Tile(value: Int.random(in: 1...10) == 1 ? 4 : 2, row: row, col: col)
        tile.isNew = true
        tiles.append(tile)
    }

    // MARK: - Slide Logic

    private func slide(grid: [[Int]], direction: MoveDirection) -> ([[Int]], Int) {
        var result = grid
        var gained = 0

        switch direction {
        case .left:
            for row in 0..<gridSize {
                let (line, pts) = slideLine(Array(result[row]))
                result[row] = line
                gained += pts
            }
        case .right:
            for row in 0..<gridSize {
                let (line, pts) = slideLine(Array(result[row].reversed()))
                result[row] = Array(line.reversed())
                gained += pts
            }
        case .up:
            for col in 0..<gridSize {
                let column = (0..<gridSize).map { result[$0][col] }
                let (line, pts) = slideLine(column)
                for row in 0..<gridSize { result[row][col] = line[row] }
                gained += pts
            }
        case .down:
            for col in 0..<gridSize {
                let column = (0..<gridSize).map { result[$0][col] }.reversed()
                let (line, pts) = slideLine(Array(column))
                for row in 0..<gridSize { result[gridSize - 1 - row][col] = line[row] }
                gained += pts
            }
        }

        return (result, gained)
    }

    private func slideLine(_ line: [Int]) -> ([Int], Int) {
        var values = line.filter { $0 > 0 }
        var gained = 0
        var i = 0
        while i < values.count - 1 {
            if values[i] == values[i + 1] {
                values[i] *= 2
                gained += values[i]
                values.remove(at: i + 1)
            }
            i += 1
        }
        while values.count < gridSize { values.append(0) }
        return (values, gained)
    }

    // MARK: - Game State Check

    private func checkGameState() {
        if tiles.contains(where: { $0.value == 2048 }) {
            gameState = .won
            return
        }
        let grid = buildGrid()
        // Check for empty cells
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if grid[row][col] == 0 { return }
            }
        }
        // Check for possible merges
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let v = grid[row][col]
                if col + 1 < gridSize && grid[row][col + 1] == v { return }
                if row + 1 < gridSize && grid[row + 1][col] == v { return }
            }
        }
        gameState = .lost
    }
}
