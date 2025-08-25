//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//
// This code was taken and modified from Paul Hudsons book
// Swift On Sundays.
//

import Foundation

enum PlacementType: CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft

    var movement: (x: Int, y: Int) {
        switch self {
        case .leftRight: return (1, 0)
        case .rightLeft: return (-1, 0)
        case .upDown: return (0, 1)
        case .downUp: return (0, -1)
        case .topLeftBottomRight: return (1, 1)
        case .topRightBottomLeft: return (-1, 1)
        case .bottomLeftTopRight: return (1, -1)
        case .bottomRightTopLeft: return (-1, -1)
        }
    }
}

enum Difficulty: Int, Identifiable, CaseIterable, CustomStringConvertible {
    case easy
    case medium
    case hard

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .easy:
            return "Easy (left/right, up/down"
        case .medium:
            return "Medium (left/right, up/down, right/left, down/up)"
        case .hard:
            return "Hard (all directions)"
        }
    }

    var shortDescription: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }

    var placementTypes: [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight, .upDown].shuffled()

        case .medium:
            return [.leftRight, .rightLeft, .upDown, .downUp].shuffled()

        case .hard:
            return PlacementType.allCases.shuffled()
        }
    }
}

class LetterLabel {
    var letter: Character = " "
}

class WordSearch {
    var words = [String]()
    var gridSize = Constants.tileCountPerRow

    var labels = [[LetterLabel]]()
    var difficulty = Difficulty.hard

    let allLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    init(words: [String], difficulty: Difficulty = Difficulty.hard) {
        self.words = words
        self.difficulty = difficulty
    }

    /// Makes a grid of letters containing the required words.
    ///
    /// - Returns: An array of arrays (rows/columns) of the placed letters
    func makeGrid() -> [[LetterLabel]] {
        labels = (0 ..< gridSize).map { _ in
            (0 ..< gridSize).map { _ in
                LetterLabel()
            }
        }

        _ = words.shuffled().filter(place)
        fillGaps()

        return labels
    }

    /// Look for any letter slots that have not been used and fill them with random letters
    private func fillGaps() {
        for column in labels {
            for label in column where label.letter == " " {
                label.letter = allLetters.randomElement()!
            }
        }
    }

    private func labels(fromX xPos: Int, yPos: Int, word: String, movement: (x: Int, y: Int)) -> [LetterLabel]? {
        var returnValue = [LetterLabel]()

        var xPosition = xPos
        var yPosition = yPos

        for letter in word {
            let label = labels[xPosition][yPosition]

            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }

        return returnValue
    }

    private func tryPlacing(_ word: String, movement: (x: Int, y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))

        let rows = (0 ..< gridSize).shuffled()
        let cols = (0 ..< gridSize).shuffled()

        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength

                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, yPos: row, word: word, movement: movement) {
                        for (index, letter) in word.enumerated() {
                            returnValue[index].letter = letter
                        }

                        return true
                    }
                }
            }
        }

        return false
    }

    private func place(_ word: String) -> Bool {
        let formattedWord = word.replacingOccurrences(of: " ", with: "").uppercased()

        return difficulty.placementTypes.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }
}
