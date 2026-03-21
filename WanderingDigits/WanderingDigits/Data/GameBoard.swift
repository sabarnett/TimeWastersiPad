//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 19/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class GameBoard {
    /// This is the live game board that the player plays on.
    var rows: [GameRow] = [
        GameRow(values: ["0"]),
        GameRow(values: ["0"]),
        GameRow(values: ["0"])
    ]

    /// This is a copy of the game board before one of the digits is moved. It allows
    /// us to have the solution ready for anyone that needs to access it. It will be used
    /// when the player asks to see the solution.
    private(set) var solution: [GameRow] = [
        GameRow(values: ["0"]),
        GameRow(values: ["0"]),
        GameRow(values: ["0"])
    ]

    /// Returns the GameRow at the selected index
    /// - Parameter index: The index of the row to retrieve. This will be in the range 0...2
    /// - Returns: The selected GameRow
    func row(at index: Int) -> GameRow {
        guard index >= 0, index < rows.count else {
            fatalError("Row index out of bounds: \(index)")
        }
        return rows[index]
    }

    /// Resets the game board, generating new numbers, and a new result row.
    func reset() {
        rows.removeAll()
        rows.append(generateNumber(mathOperator: ["+", "-"].randomElement() ?? "+"))
        rows.append(generateNumber(mathOperator: "="))
        rows.append(generateResultRow())

        solution = duplicateBoard()

        print("Debug: Correct structure state:")
        print(solution)

        shuffleDigit()
    }
    
    /// Check whether the game will be completed if the move is made.
    ///
    /// - Parameters:
    ///   - item: The number that was moved
    ///   - fromArray: The row that the number is coming from
    ///   - fromIndex: The index of the number in the source array
    ///   - toArray: The row that the number is to be inserted into
    ///   - toIndex: The position in the row that the number should be inserted
    ///
    /// - Returns: Returns True if the move results in a correct solution, else False
    func checkMove(item: String,
                   fromArray: Int, fromIndex: Int,
                   toArray: Int, toIndex: Int) -> Bool {

        // We create a working copy of the current state of the game
        // and apply the changes to it. We can then use this to check
        // whether the solution is correct
        let board = duplicateBoard()

        board[fromArray].values.remove(at: fromIndex)
        board[toArray].values.insert(item, at: toIndex)

        if board[0].mathOperator == "+" {
            return board[2].target == (board[0].target + board[1].target)
        } else {
            return board[2].target == (board[0].target - board[1].target)
        }
    }

    /// Generates a random GameRow number with 3-5 numbers in it.
    ///
    /// - Parameter mathOperator: The math operator for the game. This will be + or - or =
    /// - Returns: The completed GameRow. Numbers will always have a leading non-zero value.
    private func generateNumber(mathOperator: String) -> GameRow {
        let count = Int.random(in: 3...5)
        var gameNumbers = (0..<count).map { _ in String(Int.random(in: 0...9)) }
        gameNumbers[0] = String(Int.random(in: 1...9))

        return GameRow(values: gameNumbers, mathOperator: mathOperator)
    }
    
    /// Generates the result row. This will be the result of adding or subtracting the two random number
    /// rows.
    /// 
    /// - Returns: A completed GameRow with the calculated result of adding or subtracting the numbers.
    private func generateResultRow() -> GameRow {
        let value1 = row(at: 0).target
        let value2 = row(at: 1).target

        var expectedResult = 0
        if row(at: 0).mathOperator == "+" {
            expectedResult = value1 + value2
        } else {
            expectedResult = value1 - value2
        }

        let resultArray = String(expectedResult).map { String($0) }
        return GameRow(values: resultArray)
    }
    
    /// Takes the three game rows and shuffles one of the digits. Only one digit will be moved. It will be
    /// taken from a row selected at random and in a position at random. It will then be inserted into
    /// a random position in one of the two remaining lines.
    ///
    /// It is important to understand that we may have a negative number, so we need to make sure
    /// we are not m0ving the minus sign.
    private func shuffleDigit() {
        let indexes = [0, 1, 2].shuffled()

        // Remove a digit from the array at the first index. We need to check
        // whether the selected character is a - sign and adjust to the next
        // character if it is.
        var randomRemoval = rows[indexes[0]].indices.randomElement()!
        if rows[indexes[0]].value(at: randomRemoval) == "-" {
            randomRemoval += 1
        }
        let movedItem = rows[indexes[0]].values.remove(at: randomRemoval)

        // Insert it into a random position in the arrat at the second index. We
        // need to check whether we are inserting in front of the - sign and adjust
        // the position if it is.
        var randomInsert = rows[indexes[1]].indices.randomElement()!
        if rows[indexes[1]].value(at: randomInsert) == "-" {
            randomInsert += 1
        }
        rows[indexes[1]].values.insert(movedItem, at: randomInsert)
    }

    /// createSolution copies the game board prior to it's numbers being jumbled up. This
    /// is a convenience for the reveal popup.
    fileprivate func duplicateBoard() ->[GameRow] {
        var boardCopy: [GameRow] = []

        boardCopy.append(GameRow(values: rows[0].values.map { $0 },
                                mathOperator: rows[0].mathOperator))
        boardCopy.append(GameRow(values: rows[1].values.map { $0 },
                                mathOperator: rows[1].mathOperator))
        boardCopy.append(GameRow(values: rows[2].values.map { $0 },
                                mathOperator: rows[2].mathOperator))

        return boardCopy
    }
}
