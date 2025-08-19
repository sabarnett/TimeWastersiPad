//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 27/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents
import AVKit

enum GameState {
    case active
    case draw
    case playerWin
    case computerWin
}

class TicTacToeGameModel: ObservableObject {

    @AppStorage(Constants.PlayerWins) var playerWins = 0
    @AppStorage(Constants.ComputerWins) var computerWins = 0
    @AppStorage(Constants.DrawsCount) var draws = 0
    @AppStorage(Constants.PlaySounds) var playSounds: Bool = true

    @Published var gameBoard: [PuzzleTile] = []
    @Published var messages: String = "Your Move"
    @Published var playersGo: Bool = true

    @Published var showGamePlay: Bool = false
    @Published var gameState: GameState = .active

    @Published var speakerIcon: String = "speaker.fill"

    @Published var notifyMessage: ToastConfig?

    init() {
        initialiseGameBoard()
        speakerIcon = playSounds ? "speaker.slash.fill" : "speaker.fill"
    }

    /// Accept the players move
    ///
    /// - Parameter tile: The tile the player tapped on.
    ///
    /// The player tapped on a tile. We need to first check that the tile is empty (which
    /// it should be because used tiles are disabled) and we need to check that ity's the
    /// players turn (belt and braces check to ensure we don't get two taps).
    ///
    /// Once we have the tap, we flip the playersGo flag to stop tyhe player tapping a
    /// second tile. We then set the selected tile to the player state and check whether
    /// the game has been won.
    ///
    /// Assuming it hasn't, we tell the user that it's the computers turn and drop out.
    ///
    func setPlayerState(_ tile: PuzzleTile) -> Bool {
        guard gameState == .active else { return false }
        guard tile.state == .empty else { return false }
        guard playersGo else { return false }

        playersGo.toggle()
        objectWillChange.send()

        playPlayerClick()
        tile.state = .player
        if checkForWin(.player) {
            playerWins += 1
            playPlayerWins()
            gameState = .playerWin
            messages = "You win!!!"
            return false
        }

        if checkForDraw() {
            return false
        }

        messages = "My turn... thinking..."
        return true
    }

    /// Calculate the computers go.
    ///
    /// We can do fewer checks here as we know this code will only be called when
    /// it is the computers turn. We use a simple algorithm to calculate the tile that
    /// the computer wants to play and we set that tile state.
    ///
    /// Once the state has been set, we check for a win or a draw. If no one has won
    /// or there is no draw, we set the flag to indicate the players go, let the player know
    /// it's their turn and drop out.
    ///
    func setComputerState() {
        guard gameState == .active else { return }

        playComputerClick()
        let computersGo = computerTry()
        gameBoard[computersGo].state = .computer

        if checkForWin(.computer) {
            computerWins += 1
            playComputerWins()
            gameState = .computerWin
            messages = "You lost!"
            return
        }

        if checkForDraw() {
            return
        }

        playersGo.toggle()
        messages = "Your turn..."
    }

    /// Reset the game - clear the board, clear scores
    func resetGame() {
        initialiseGameBoard()

        playerWins = 0
        computerWins = 0
        draws = 0

        notifyMessage = ToastConfig(message: "Game reset", type: .info)

        decideWhoGoesFirst()
        gameState = .active
    }

    /// Game was won/lost/drawn and the player clicked the button for a new game. We
    /// need to re-initialise the board, reset te=he game state and select who starts first.
    func newGame() {
        initialiseGameBoard()

        gameState = .active
        decideWhoGoesFirst()
    }

    /// Determine whether the player starts or the computer does. The decision is
    /// biased in favour of the player over the computer.
    func decideWhoGoesFirst() {
        if Int.random(in: 0...10) <= 3 {
            playersGo = false
            setComputerState()
        } else {
            playersGo = true
        }
    }

    /// Check for a draw - this is where all tiles have been set but no winner has
    /// been found. We can assume that, if the player or computer won, we won't ever
    /// get to this code, so we can assume a full board is a drawn board.
    private func checkForDraw() -> Bool {
        if gameBoard.filter({$0.state == .empty}).count == 0 {
            draws += 1
            playDraw()
            gameState = .draw
            messages = "It's a draw"

            return true
        }
        return false
    }

    /// The game board is a 3x3 array of tiles. To keep the code uncomplocated, we
    /// keep these tiles in a single dimension array of 9 tiles.
    private func initialiseGameBoard() {
        gameBoard = []
        for _ in 0..<9 {
            gameBoard.append(PuzzleTile(state: .empty))
        }
    }

    // MARK: - Sound functions

    private var sounds: AVAudioPlayer!
    private var playerWinURL: URL { soundFile(named: Constants.PlayerWinSound) }
    private var computerWinURL: URL { soundFile(named: Constants.ComputerWinSound) }
    private var drawURL: URL { soundFile(named: Constants.DrawSound) }
    private var playerClickURL: URL { soundFile(named: Constants.PlayerClickSound) }
    private var computerClickURL: URL { soundFile(named: Constants.ComputerClickSound) }

    /// If the background music is playing, stop it.
    func stopSounds() {
        if sounds != nil {
            sounds.stop()
        }
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playPlayerWins() { playSound(playerWinURL) }
    func playComputerWins() { playSound(computerWinURL) }
    func playDraw() { playSound(drawURL) }
    func playPlayerClick() { playSound(playerClickURL) }
    func playComputerClick() { playSound(computerClickURL) }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        playSounds.toggle()

        speakerIcon = playSounds ? "speaker.slash.fill" : "speaker.fill"

        if !playSounds {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: TicTacToeGameModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL) {
        guard playSounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = 0
            self.sounds.play()
        }
    }

}

extension TicTacToeGameModel {

    /**
     1. See if there’s a move the computer can make that will win the game. If there is,
        take that move. Otherwise, go to step 2.

     2. See if there’s a move the player can make that will cause the computer to lose the game. If there is,
        the computer should move there to block the player. Otherwise, go to step 3.

     3. Check if any of the corners (spaces 1, 3, 7, or 9) are free. If no corner space is free, go to step 4.

     4. Check if the center is free. If so, move there. If it isn’t, go to step 5.

     5. Move on any of the sides (spaces 2, 4, 6, or 8). There are no more steps, because the side spaces
        are the only spaces left if the execution has reached this step.

     The function will return an integer from 1 to 9 representing the computer’s move.
     */
    private func computerTry() -> Int {
        if let move = computerWinningMove() { return move }
        if let move = playerWinningMove() { return move }
        if let move = checkCorners() { return move }
        if let move = checkCenter() { return move }
        if let move = checkSides() { return move }
        return 0
    }

    /// 1. See if there’s a move the computer can make that will win the
    /// game. If there is, take that move. Otherwise, go to step 2.
    private func computerWinningMove() -> Int? {
        if let move = checkCells(topRow, state: .computer) { return move }
        if let move = checkCells(middleRow, state: .computer) { return move }
        if let move = checkCells(bottomRow, state: .computer) { return move }
        if let move = checkCells(columnOne, state: .computer) { return move }
        if let move = checkCells(columnTwo, state: .computer) { return move }
        if let move = checkCells(columnThree, state: .computer) { return move }
        if let move = checkCells(leftDiagonal, state: .computer) { return move }
        if let move = checkCells(rightDiagonal, state: .computer) { return move }

        // No winning move
        return nil
    }

    /// 2. See if there’s a move the player can make that will cause the computer
    /// to lose the game. If there is, the computer should move there to block the
    /// player. Otherwise, go to step 3.
    private func playerWinningMove() -> Int? {
        if let move = checkCells(topRow, state: .player) { return move }
        if let move = checkCells(middleRow, state: .player) { return move }
        if let move = checkCells(bottomRow, state: .player) { return move }
        if let move = checkCells(columnOne, state: .player) { return move }
        if let move = checkCells(columnTwo, state: .player) { return move }
        if let move = checkCells(columnThree, state: .player) { return move }
        if let move = checkCells(leftDiagonal, state: .player) { return move }
        if let move = checkCells(rightDiagonal, state: .player) { return move }

        // No winning move
        return nil
    }

    /// 3. Check if any of the corners (spaces 1, 3, 7, or 9) are free. If no
    /// corner space is free, go to step 4.
    private func checkCorners() -> Int? {
        if let cell = corners.filter({ $0.state == .empty }).randomElement() {
            return gameBoard.firstIndex(where: {$0.id == cell.id })
        }
        return nil
    }

    /// 4. Check if the center is free. If so, move there. If it isn’t, go to step 5.
    private func checkCenter() -> Int? {
        if gameBoard[4].state == .empty { return 4 }
        return nil
    }

    /// 5. Move on any of the sides (spaces 2, 4, 6, or 8). There are no more
    /// steps, because the side spaces are the only spaces left if the execution
    /// has reached this step.
    private func checkSides() -> Int? {
        if let cell = sides.filter({ $0.state == .empty }).randomElement() {
            return gameBoard.firstIndex(where: {$0.id == cell.id })
        }
        return nil
    }

    /// Checks whether we have a potential willing move. This is determined by checking
    /// whether there are two tiles for the selected player with an empty tile on the same
    /// winning line.
    ///
    /// - Parameters:
    ///   - cells: The array of three tiles that represent apotential willing line.
    ///   - state: Indicates whether we are looking for player wins or computer wins.
    ///
    /// - Returns: The tile to select for a winning line or nil of there is no willing move.
    private func checkCells(_ cells: [PuzzleTile], state: TileState) -> Int? {
        if cells.filter({ $0.state == state }).count == 2
        && cells.filter({ $0.state == .empty }).count == 1 {
            let cell = cells.filter({ $0.state == .empty }).first
            return gameBoard.firstIndex(where: {$0.id == cell!.id })
        }

        return nil
    }
}

extension TicTacToeGameModel {

    // Winning moves
    // Top row      [0,1,2]
    // Middle row   [3,4,5]
    // Bottom row   [6,7,8]
    // Column 1     [0,3,6]
    // Column 2     [1,4,7]
    // Column 3     [2,5,8]
    // Right diag   [0,4,8]
    // Left diag    [2,4,6]
    var topRow: [PuzzleTile] { [ gameBoard[0], gameBoard[1], gameBoard[2] ] }
    var middleRow: [PuzzleTile] { [ gameBoard[3], gameBoard[4], gameBoard[5] ] }
    var bottomRow: [PuzzleTile] { [ gameBoard[6], gameBoard[7], gameBoard[8] ] }

    var columnOne: [PuzzleTile] { [ gameBoard[0], gameBoard[3], gameBoard[6] ] }
    var columnTwo: [PuzzleTile] { [ gameBoard[1], gameBoard[4], gameBoard[7] ] }
    var columnThree: [PuzzleTile] { [ gameBoard[2], gameBoard[5], gameBoard[8] ] }

    var rightDiagonal: [PuzzleTile] { [ gameBoard[0], gameBoard[4], gameBoard[8] ] }
    var leftDiagonal: [PuzzleTile] { [ gameBoard[2], gameBoard[4], gameBoard[6] ] }

    // Corner Cells and side cells.
    var corners: [PuzzleTile] { [ gameBoard[0], gameBoard[2], gameBoard[6], gameBoard[8]] }
    var sides: [PuzzleTile] { [ gameBoard[1], gameBoard[3], gameBoard[5], gameBoard[7]] }

    /// Checks whether the player or computer has won the game.
    ///
    /// - Parameter player: Indicates whether we are checking for player or computer wins.
    /// 
    /// - Returns: True if the selected player has won, else false.
    func checkForWin(_ player: TileState) -> Bool {
        return topRow.allSatisfy({ $0.state == player})
        || middleRow.allSatisfy({ $0.state == player})
        || bottomRow.allSatisfy({ $0.state == player})
        || columnOne.allSatisfy({ $0.state == player})
        || columnTwo.allSatisfy({ $0.state == player})
        || columnThree.allSatisfy({ $0.state == player})
        || rightDiagonal.allSatisfy({ $0.state == player})
        || leftDiagonal.allSatisfy({ $0.state == player})
    }
}
