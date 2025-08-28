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

    typealias GameBoard = [[Tile]]

    let boardWidth = 8
    let boardHeight = 8

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

    private var allTiles: [Tile] { gameBoard.flatMap({$0}) }

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
        gameBoard = createBoard()

        gameBoard[3][3].state = .player
        gameBoard[3][4].state = .computer
        gameBoard[4][3].state = .computer
        gameBoard[4][4].state = .player

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

        let position = findTile(selectedTile.id)
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
        let boardCopy = getBoardCopy(gameBoard)
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .player)

        return !possibleMoves.isEmpty
    }

    /// Checks whether the computer has any possible moves.
    ///
    /// - Returns: Truie if the computer has valid moves else false
    private func canComputerMove() -> Bool {
        let boardCopy = getBoardCopy(gameBoard)
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .computer)

        return !possibleMoves.isEmpty
    }

    /// Create an empty board. This is an array of arrays of Tile objects.
    private func createBoard() -> GameBoard {
        var board = GameBoard()

        for _ in 0..<boardWidth {
            var row = [Tile]()
            for _ in 0..<boardHeight {
                row.append(Tile())
            }
            board.append(row)
        }

        return board
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
        let marked = allTiles.filter({$0.state == .potentialPlayerMove})
        if marked.count == 0 { return }

        objectWillChange.send()
        marked.forEach {$0.state = .empty}
    }

    /// Check that the move is valid. If it is, return a list of tile positions that need to
    /// be flipped to the new player state.
    private func isValidMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> [BoardLocation]? {

        guard board[xPos][yPos].state == .empty,
                isOnBoard(xPos: xPos, yPos: yPos) else { return nil }

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

            while isOnBoard(xPos: boardX, yPos: boardY) && board[boardX][boardY].state == flipState {
                boardX += xDirection
                boardY += yDirection

                if isOnBoard(xPos: boardX, yPos: boardY) && board[boardX][boardY].state == tileState {
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

    /// Tests whether the position is on the game board or not
    /// - Parameters:
    ///   - xPos: The x position to test
    ///   - yPos: The y position to test
    /// - Returns: True if the position is valid else false.
    private func isOnBoard(xPos: Int, yPos: Int) -> Bool {
        return xPos >= 0 && xPos < boardWidth && yPos >= 0 && yPos < boardHeight
    }

    /// Using a copy of the current game board, determine what moves the player has
    /// and mark them as potential moves. The view can then be updated to highlight
    /// those moves.
    private func markPlayerPotentialMoves() {
        // We need to copy the board, so we do not modify the active gane
        let boardCopy = getBoardCopy(gameBoard)
        let validMoves = getValidMoves(board: boardCopy, tileState: .player)

        validMoves.forEach { location in
            gameBoard[location.xPos][location.yPos].state = .potentialPlayerMove
        }
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
    private func getValidMoves(board: GameBoard, tileState: TileState) -> [BoardLocation] {
        var validMoves: [BoardLocation] = []

        // We must have at least one of the selected tiles on the board
        // in order to be able to compute valid moves.
        let hasTiles = board.flatMap({$0}).filter({$0.state == tileState}).count != 0
        if !hasTiles { return validMoves }

        for xPos in 0..<boardWidth {
            for yPos in 0..<boardHeight
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
        let allTiles = board.flatMap({ $0 })
        let player = allTiles.filter({$0.state == .player}).count
        let computer = allTiles.filter({$0.state == .computer}).count

        return (player, computer)
    }

    @discardableResult
    private func makeMove(board: GameBoard, tileState: TileState, xPos: Int, yPos: Int) -> Bool {
        guard let tilesToFlip = isValidMove(board: board, tileState: tileState, xPos: xPos, yPos: yPos) else {
            return false
        }

        board[xPos][yPos].state = tileState
        tilesToFlip.forEach { location in
            board[location.xPos][location.yPos].state = tileState
        }
        return true
    }

    /// Checks whether a particular tile is on the corner of the board. Corner spots
    /// are highly prized for their tactical position.
    ///
    /// - Parameters:
    ///   - xPos: The x position on the board
    ///   - yPos: The y position on the board
    ///
    /// - Returns: True if the position is on a corner else false.
    private func isOnCorner(xPos: Int, yPos: Int) -> Bool {
        return (xPos == 0 || xPos == boardWidth - 1) && (yPos == 0 ||  yPos == boardHeight - 1)
    }

    /// Calculates the best move for the computer.
    ///
    /// - Returns: The location on the board that represents the best move for the
    /// computer; i.e. the one that captures a corner or that scores the highest score
    /// for the computer.
    private func getComputerMove() -> BoardLocation? {
        let boardCopy = getBoardCopy(gameBoard)
        let possibleMoves = getValidMoves(board: boardCopy, tileState: .computer).shuffled()

        // Prefer moves that are on the corner
        var computerCornerMove: BoardLocation?
        possibleMoves.forEach { location in
            if computerCornerMove == nil && isOnCorner(xPos: location.xPos, yPos: location.yPos) {
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
            let testCopy = getBoardCopy(gameBoard)

            makeMove(board: testCopy, tileState: .computer, xPos: location.xPos, yPos: location.yPos)
            let score = getScores(board: testCopy).computer

            if score > bestScore {
                bestScore = score
                bestMove = BoardLocation(xPos: location.xPos, yPos: location.yPos)
            }
        }
        return bestMove
    }

    /// Inordinatelt useful function to create a copy of a game board.
    ///
    /// - Parameter board: The board to copy
    /// - Returns: A new game board with the same data as the input board.
    ///
    /// Most of the game logic is based around trying out movesto find the best one. This
    /// is all done on a copy of the game board. Once we have determined the best move,
    /// we can apply it to the actual game that the player is seeing.
    ///
    /// This function is responsible for creating an empty game board and then copying the
    /// content of the passed in game board. The resulting board is a duplicate of the input
    /// one, but with new and unrelated Tile objects.
    private func getBoardCopy(_ board: GameBoard) -> [[Tile]] {
        let copy = createBoard()

        for xPos in 0..<boardWidth {
            for yPos in 0..<boardHeight {
                copy[xPos][yPos].state = board[xPos][yPos].state
            }
        }

        return copy
    }

    /// Calculate and update the scores for the game board
    private func updateScores() {
        let scores = getScores(board: gameBoard)
        self.playerScore = scores.player
        self.computerScore = scores.computer
    }

    /// Find a tile, given it's id. We can assume that the tile exists somewhere and we want the
    /// x/y position in the grid.
    ///
    /// - Parameter tileId: The id of the tile to find
    /// - Returns: The location on the gameBoard where this tile exists
    private func findTile(_ tileId: UUID) -> BoardLocation {
        for col in 0..<boardWidth {
            for row in 0..<boardHeight where gameBoard[col][row].id == tileId {
                return BoardLocation(xPos: col, yPos: row)
            }
        }
        fatalError("Could not find tile with id \(tileId)")
    }

    private func endOfGameCheck() {
        // No tiles left, set end of game state
        if allTiles.filter({$0.state == .empty}).count > 0
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
}
