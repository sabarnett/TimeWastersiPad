//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 18/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import AVKit
import SwiftUI
import SharedComponents

class OthelloViewModel: ObservableObject {

    @AppStorage(Constants.othelloPlaySounds) var othelloPlaySounds = true {
        didSet {
            updateSounds()
        }
    }

    @Published var gameBoard = GameBoard()
    @Published var playerScore = 0
    @Published var computerScore = 0
    @Published var statusMessage = " "
    @Published var gameState: GameState = .playerMove
    @Published var showGamePlay: Bool = false
    @Published var speakerIcon = ""
    @Published var leaderBoard = LeaderBoard()

    @Published var notifyMessage: ToastConfig?

    var tiles: [[Tile]] { gameBoard.board }
    var tileCount: Int { gameBoard.board.count }

    var sounds: AVAudioPlayer!
    var chimeSound: AVAudioPlayer!
    var backgroundURL: URL { soundFile(named: "background") }
    var chimeURL: URL { soundFile(named: "chime") }

    init() {
        newGame()
        speakerIcon = othelloPlaySounds ? "speaker.slash" : "speaker"
        if othelloPlaySounds {
            playBackgroundSound()
        }
    }

    /// Starts a new game. This involves creating a new game board, setting
    /// the initial board state where there are four tiles in the middle (2x player
    /// and 2x computer).
    ///
    /// Once we have a board, we randomly choose who goes first, with a bias
    /// towards the player rather than the computer.
    func newGame() {
        gameBoard = GameBoard()

        playerScore = 2
        computerScore = 2

        // who goes first; player or computer?
        if Int.random(in: 0..<3) == 0 {
            gameState = .computerMove
            computerMove()
        } else {
            statusMessage = "You go first!"
            gameState = .playerMove
        }
    }

    /// Player selected a tile, ensure the move is valid and flip the tile
    /// if it is.
    func select(tile selectedTile: Tile) -> Bool {
        guard gameState == .playerMove else { return false }
        guard selectedTile.state == .empty || selectedTile.state == .potentialPlayerMove else {
            statusMessage = "That tile is not empty, please try again."
            return false
        }

        gameState = .computerMove
        resetHints()

        objectWillChange.send()

        let position = gameBoard.findTile(selectedTile.id)
        if !makeMove(board: gameBoard, tileState: .player, xPos: position.xPos, yPos: position.yPos) {
            statusMessage = "Invalid move, please try again."
            gameState = .playerMove
            return false
        }

        playChime()
        updateScores()
        statusMessage = "My move... thinking..."

        endOfGameCheck()
        return true
    }

    /// Calculate the computers move. Assuming the computer can move, we place the
    /// computer tile, flip any that need flipping and update the scores.
    func computerMove() {
        guard gameState == .computerMove || gameState == .noValidMove else { return }
        guard let computer = getComputerMove() else {
            notifyMessage = ToastConfig(message: "I have no moves",
                                        icon: "circle.slash.fill",
                                        type: .info
            )
            statusMessage = "I cannot move, you get the next turn..."

            if canPlayerMove() {
                gameState = .playerMove
                return
            }

            endOfGameCheck()
            return
        }
        makeMove(board: gameBoard, tileState: .computer, xPos: computer.xPos, yPos: computer.yPos)
        updateScores()

        if !canPlayerMove() {
            statusMessage = "You cannot move, my try again..."
            notifyMessage = ToastConfig(message: "You cannot move",
                                        icon: "circle.slash.fill",
                                        type: .info
            )
            gameState = .noValidMove
        } else {
            gameState = .playerMove
            statusMessage = "Your move..."
        }

        endOfGameCheck()
    }

    /// Checks whether the player has any possible moves.
    ///
    /// - Returns: Truie if the player has valid moves else false
    private func canPlayerMove() -> Bool {
        let boardCopy = gameBoard.getBoardCopy()
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .player)

        return !possibleMoves.isEmpty
    }

    /// Checks whether the computer has any possible moves.
    ///
    /// - Returns: Truie if the computer has valid moves else false
    private func canComputerMove() -> Bool {
        let boardCopy = gameBoard.getBoardCopy()
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .computer)

        return !possibleMoves.isEmpty
    }

    /// Check that the move is valid. If it is, return a list of tile positions that need to
    /// be flipped to the new player state.
    private func isValidMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> [BoardLocation]? {

        guard board.tileAt(xPos: xPos, yPos: yPos).state == .empty,
              board.isOnBoard(xPos: xPos, yPos: yPos) else { return nil }

        var tilesToFlip = [BoardLocation]()
        let flipState: TileState = tileState == .player ? .computer : .player

        // Array of the offsets from the current tile to scan.
        let scanDirections: [(Int, Int)] = [
            (1, 0), (0, 1), (-1, 0), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1)
        ]

        scanDirections.forEach { (xDirection, yDirection) in
            var boardX = xPos + xDirection
            var boardY = yPos + yDirection

            while board.isOnBoard(xPos: boardX, yPos: boardY)
                    && board.tileAt(xPos: boardX, yPos: boardY).state == flipState {
                boardX += xDirection
                boardY += yDirection

                if board.isOnBoard(xPos: boardX, yPos: boardY)
                    && board.tileAt(xPos: boardX, yPos: boardY).state == tileState {
                    while true {
                        boardX -= xDirection
                        boardY -= yDirection
                        if boardX == xPos && boardY == yPos {
                            break
                        }
                        tilesToFlip.append(BoardLocation(xPos: boardX, yPos: boardY))
                    }
                }
            }
        }

        return tilesToFlip.count > 0 ? tilesToFlip : nil
    }

    /// Determine which moves are valid. We cycle through all cells in the game board and check
    /// whether that cell is a valid cell to select. If it is, we add it to an array of valid moves. We can
    /// use this to determine what cells the computer can move to.
    ///
    /// - Parameters:
    ///   - board: The game board to use to check against
    ///   - tileState: Whether this is a computer or player move
    ///
    /// - Returns: An array of possible moves.
    internal func getValidMoves(board: GameBoard, tileState: TileState) -> [BoardLocation] {
        var validMoves: [BoardLocation] = []

        // We must have at least one of the selected tiles on the board
        // in order to be able to compute valid moves.
        let hasTiles = board.allTiles.filter({$0.state == tileState}).count != 0
        if !hasTiles { return validMoves }

        for xPos in 0..<board.boardWidth {
            for yPos in 0..<board.boardHeight
                where isValidMove(board: board, tileState: tileState, xPos: xPos, yPos: yPos) != nil {
                    validMoves.append(BoardLocation(xPos: xPos, yPos: yPos))
            }
        }
        return validMoves
    }

    /// Calculates the score for the player and computer in the passed in game board. This could
    /// be the real game board or a copy of the game board used to determine the best score
    /// for the computer.
    ///
    /// - Parameter board: The board to be scanned
    /// - Returns: The player and computer scores on the board
    private func getScores(board: GameBoard) -> (player: Int, computer: Int) {
        let allTiles = board.allTiles
        let player = allTiles.filter({$0.state == .player}).count
        let computer = allTiles.filter({$0.state == .computer}).count

        return (player, computer)
    }

    @discardableResult
    private func makeMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> Bool {
        guard let tilesToFlip = isValidMove(board: board, tileState: tileState, xPos: xPos, yPos: yPos) else {
            return false
        }

        board.board[xPos][yPos].state = tileState
        tilesToFlip.forEach { location in
            board.tileAt(location: location).state = tileState
        }
        return true
    }

    /// Calculates the best move for the computer.
    ///
    /// - Returns: The location on the board that represents the best move for the
    /// computer; i.e. the one that captures a corner or that scores the highest score
    /// for the computer.
    private func getComputerMove() -> BoardLocation? {
        let boardCopy = gameBoard.getBoardCopy()
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .computer).shuffled()

        // Prefer moves that are on the corner
        var computerCornerMove: BoardLocation?
        possibleMoves.forEach { location in
            if computerCornerMove == nil && boardCopy.isOnCorner(xPos: location.xPos, yPos: location.yPos) {
                computerCornerMove = BoardLocation(xPos: location.xPos, yPos: location.yPos)
            }
        }
        if let computerCornerMove {
            return computerCornerMove
        }

        // Find the highest scoring move
        var bestScore = -1
        var bestMove: BoardLocation?

        possibleMoves.forEach { location in
            let testCopy = gameBoard.getBoardCopy()

            makeMove(board: testCopy, tileState: .computer, xPos: location.xPos, yPos: location.yPos)
            let score = getScores(board: testCopy).computer

            if score > bestScore {
                bestScore = score
                bestMove = BoardLocation(xPos: location.xPos, yPos: location.yPos)
            }
        }
        return bestMove
    }

    /// Calculate and update the scores for the game board
    private func updateScores() {
        let scores = getScores(board: gameBoard)
        self.playerScore = scores.player
        self.computerScore = scores.computer
    }

    private func endOfGameCheck() {
        // No tiles left, set end of game state
        if gameBoard.allTiles.filter({$0.state == .empty}).count > 0
            || canPlayerMove()
            || canComputerMove() {
            return
        }

        // If we get here, the checks are complete and the game is over
        statusMessage = "Game over!"

        if playerScore > computerScore {
            gameState = .playerWin
            leaderBoard.addLeader(score: playerScore, for: .player)
        } else {
            gameState = .computerWin
            leaderBoard.addLeader(score: computerScore, for: .computer)
        }
    }

    /// Mark the cells the player could potentially select. After they have been on
    /// the scteen for 3.5 seconds, clear them away again.
    @MainActor
    func showHint() {
        objectWillChange.send()
        markPlayerPotentialMoves()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.resetHints()
        }
    }

    /// If there are cells highlighted as potential user moves, reset them back to empty. This
    /// will remove them from the game board.
    private func resetHints() {
        let marked = gameBoard.allTiles.filter({$0.state == .potentialPlayerMove})
        if marked.count == 0 { return }

        objectWillChange.send()
        marked.forEach {$0.state = .empty}
    }

    /// Using a copy of the current game board, determine what moves the player has
    /// and mark them as potential moves. The view can then be updated to highlight
    /// those moves.
    private func markPlayerPotentialMoves() {
        // We need to copy the board, so we do not modify the active gane
        let boardCopy = gameBoard.getBoardCopy()
        let validMoves = getValidMoves(board: boardCopy, tileState: .player)

        validMoves.forEach { location in
            gameBoard.board[location.xPos][location.yPos].state = .potentialPlayerMove
        }
    }
}
