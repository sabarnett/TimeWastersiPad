//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 26/09/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class GameBoard {
    var board = [[Tile]]()

    let boardWidth = 8
    let boardHeight = 8

    var allTiles: [Tile] { board.flatMap({$0}) }

    init() {
        board = createBoard()

        board[3][3].state = .player
        board[3][4].state = .computer
        board[4][3].state = .computer
        board[4][4].state = .player
    }

    /// Tests whether the position is on the game board or not
    /// - Parameters:
    ///   - xPos: The x position to test
    ///   - yPos: The y position to test
    /// - Returns: True if the position is valid else false.
    func isOnBoard(xPos: Int, yPos: Int) -> Bool {
        return xPos >= 0 && xPos < boardWidth && yPos >= 0 && yPos < boardHeight
    }

    /// Checks whether a particular tile is on the corner of the board. Corner spots
    /// are highly prized for their tactical position.
    ///
    /// - Parameters:
    ///   - xPos: The x position on the board
    ///   - yPos: The y position on the board
    ///
    /// - Returns: True if the position is on a corner else false.
    func isOnCorner(xPos: Int, yPos: Int) -> Bool {
        return (xPos == 0 || xPos == boardWidth - 1) && (yPos == 0 ||  yPos == boardHeight - 1)
    }

    /// Find a tile, given it's id. We can assume that the tile exists somewhere and we want the
    /// x/y position in the grid.
    ///
    /// - Parameter tileId: The id of the tile to find
    /// - Returns: The location on the gameBoard where this tile exists
    func findTile(_ tileId: UUID) -> BoardLocation {
        for col in 0..<boardWidth {
            for row in 0..<boardHeight where board[col][row].id == tileId {
                return BoardLocation(xPos: col, yPos: row)
            }
        }
        fatalError("Could not find tile with id \(tileId)")
    }

    func tileAt(xPos: Int, yPos: Int) -> Tile {
        if isOnBoard(xPos: xPos, yPos: yPos) {
            return board[xPos][yPos]
        }
        fatalError("Requested tile position \(xPos), \(yPos) is invalid.")
    }

    func tileAt(location: BoardLocation) -> Tile {
        return tileAt(xPos: location.xPos, yPos: location.yPos)
    }

    /// Inordinately useful function to create a copy of a game board.
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
    internal func getBoardCopy() -> GameBoard {
        let copy = GameBoard()

        for xPos in 0..<boardWidth {
            for yPos in 0..<boardHeight {
                copy.board[xPos][yPos].state = board[xPos][yPos].state
            }
        }

        return copy
    }

    /// Create an empty board. This is an array of arrays of Tile objects.
    private func createBoard() -> [[Tile]] {
        var board = [[Tile]]()

        for _ in 0..<boardWidth {
            var row = [Tile]()
            for _ in 0..<boardHeight {
                row.append(Tile())
            }
            board.append(row)
        }

        return board
    }
}
