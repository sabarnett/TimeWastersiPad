//
// -----------------------------------------
// Original project: Minesweeper
// Original package: Minesweeper
// Created on: 10/08/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

@Observable
class MinesweeperGame {

    @ObservationIgnored
    @AppStorage(Constants.mineGameDifficulty) var mineGameDifficulty: GameDifficulty = .beginner

    private var cellCount: Int {
        switch mineGameDifficulty {
        case .beginner: return 9
        case .intermediate: return 16
        case .expert: return 22
        }
    }

    private var mineCount: Int {
        switch mineGameDifficulty {
        case .beginner: return 10
        case .intermediate: return 25
        case .expert: return 60
        }
    }

    public var rows = [[Square]]()

    public var gameState = GameState.waiting
    public var secondsElapsed = 0
    public var isHoveringOverRestart = false

    public var minesFound: Int { max(0, minedSquares.count - flaggedSquares.count) }

    private var allSquares: [Square] { rows.flatMap { $0 } }
    private var revealedSquares: [Square] { allSquares.filter(\.isRevealed) }
    private var flaggedSquares: [Square] { allSquares.filter(\.isFlagged) }
    private var minedSquares: [Square] { allSquares.filter(\.hasMine) }
    private var hiddenSquares: [Square] { allSquares.filter({ $0.isRevealed == false})}

    public var isWon: Bool { gameState == .won }
    public var isLost: Bool { gameState == .lost }
    public var isPlaying: Bool { gameState == .playing }
    public var isWaiting: Bool { gameState == .waiting }

    public var leaderBoard: LeaderBoard = LeaderBoard()

    public var playingAreaWidth: CGFloat {
        let (cellWidth, paddingWidth) = switch mineGameDifficulty {
        case .beginner:  (60.0, 35.0)
        case .intermediate:  (50.0, 50.0)
        case .expert:  (35.0, 60.0)
        }
        return Double(cellCount) * cellWidth + paddingWidth
    }
    public var statusEmoji: String {
        if isHoveringOverRestart {
            "😮"
        } else {
            switch gameState {
            case .waiting, .playing: "🙂"
            case .won:               "😎"
            case .lost:              "😵"
            }
        }
    }

    public func createGrid() {
        rows.removeAll()

        for row in 0..<cellCount {
            var rowSquares = [Square]()

            for column in 0..<cellCount {
                let square = Square(row: row, column: column)
                rowSquares.append(square)
            }

            rows.append(rowSquares)
        }
    }

    func square(atRow row: Int, column: Int) -> Square? {
        if row < 0 { return nil }
        if row >= rows.count { return nil }
        if column < 0 { return nil }
        if column >= rows[row].count { return nil }
        return rows[row][column]
    }

    func getAdjacentSquares(toRow row: Int, column: Int) -> [Square] {
        var result = [Square?]()

        result.append(square(atRow: row - 1, column: column - 1))
        result.append(square(atRow: row - 1, column: column))
        result.append(square(atRow: row - 1, column: column + 1))

        result.append(square(atRow: row, column: column - 1))
        result.append(square(atRow: row, column: column + 1))

        result.append(square(atRow: row + 1, column: column - 1))
        result.append(square(atRow: row + 1, column: column))
        result.append(square(atRow: row + 1, column: column + 1))

        return result.compactMap { $0 }
    }

    func placeMines(avoiding: Square) {
        var possibleSquares = allSquares
        let disallowed = getAdjacentSquares(toRow: avoiding.row, column: avoiding.column) + CollectionOfOne(avoiding)
        possibleSquares.removeAll(where: disallowed.contains)

        for square in possibleSquares.shuffled().prefix(mineCount) {
            square.hasMine = true
        }

        for row in rows {
            for square in row {
                let adjacentSquares = getAdjacentSquares(toRow: square.row, column: square.column)
                square.nearbyMines = adjacentSquares.filter(\.hasMine).count
            }
        }
    }

    func select(_ square: Square) {
        guard gameState == .waiting || gameState == .playing else { return }
        guard square.isRevealed == false else { return }
        guard square.isFlagged == false else { return }

        if revealedSquares.count == 0 {
            placeMines(avoiding: square)
            gameState = .playing
        }

        if square.hasMine == false && square.nearbyMines == 0 {
            reveal(square)
        } else {
            square.isRevealed = true

            if square.hasMine {
                gameState = .lost

                for square in hiddenSquares {
                    square.isRevealed = true
                }
                return
            }
        }

        checkForWin()
    }

    func reveal(_ square: Square) {
        guard square.isRevealed == false else { return }
        guard square.isFlagged == false else { return }
        square.isRevealed = true

        if square.nearbyMines == 0 {
            let adjacentSquares = getAdjacentSquares(toRow: square.row, column: square.column)

            for adjacentSquare in adjacentSquares {
                reveal(adjacentSquare)
            }
        }
    }

    func flag(_ square: Square) {
        guard square.isRevealed == false else { return }
        square.isFlagged.toggle()
    }

    func checkForWin() {
        if revealedSquares.count == allSquares.count - minedSquares.count {
            gameState = .won
            leaderBoard.addLeader(score: secondsElapsed, forLevel: mineGameDifficulty)
        }
    }

    func reset() {
        secondsElapsed = 0
        gameState = .waiting
        createGrid()
    }
}
