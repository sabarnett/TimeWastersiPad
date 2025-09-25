//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 25/09/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

extension OthelloViewModel {
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
    internal func resetHints() {
        let marked = allTiles.filter({$0.state == .potentialPlayerMove})
        if marked.count == 0 { return }

        objectWillChange.send()
        marked.forEach {$0.state = .empty}
    }

    /// Using a copy of the current game board, determine what moves the player has
    /// and mark them as potential moves. The view can then be updated to highlight
    /// those moves.
    internal func markPlayerPotentialMoves() {
        // We need to copy the board, so we do not modify the active gane
        let boardCopy = getBoardCopy(gameBoard)
        let validMoves = getValidMoves(board: boardCopy, tileState: .player)

        validMoves.forEach { location in
            gameBoard[location.xPos][location.yPos].state = .potentialPlayerMove
        }
    }
}
