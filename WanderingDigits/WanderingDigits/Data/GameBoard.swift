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
    var rows: [GameRow] = [
        GameRow(values: ["0"]),
        GameRow(values: ["0"]),
        GameRow(values: ["0"])
    ]

    func row(at index: Int) -> GameRow {
        guard index >= 0, index < rows.count else {
            fatalError("Row index out of bounds: \(index)")
        }
        return rows[index]
    }
    
    func reset() {
        rows.removeAll()
        rows.append(generateNumber(mathOperator: ["+", "-"].randomElement() ?? "+"))
        rows.append(generateNumber(mathOperator: "="))
        rows.append(generateResultRow())

        print("Debug: Correct structure state:")
        print(rows)
    }

    private func generateNumber(mathOperator: String) -> GameRow {
        let count = Int.random(in: 3...5)
        var gameNumbers = (0..<count).map { _ in String(Int.random(in: 0...9)) }
        gameNumbers[0] = String(Int.random(in: 1...9))

        return GameRow(values: gameNumbers, mathOperator: mathOperator)
    }

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
}
