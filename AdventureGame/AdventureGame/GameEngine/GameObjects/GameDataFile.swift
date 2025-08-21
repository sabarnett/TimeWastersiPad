//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

public protocol GameDataReaderProtocol {
    init(dataSet: String)
    func readInt() throws -> Int
    func nextLine() -> String
    var numberOfLines: Int { get }
    var currentLine: Int { get }
    func reset()
    func nextLineIsNumeric() -> Bool
}

public enum GameDataReaderErrors: Error {
    case integerExpected(errorMessage: String)
    case pastEndOfFile
}

public class GameDataReader: GameDataReaderProtocol {

    private let quotes: String = "\""

    private let gameLines: [String]
    private var lineNumber: Int = -1

    required public init(dataSet: String) {
        gameLines = dataSet.replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\t", with: "")
            .components(separatedBy: "\n")
        lineNumber = 0
    }

    public func readInt() throws -> Int {

        let nextValue = (try? readLine())!
        if let number = Int(nextValue) {
            return number
        }

        throw GameDataReaderErrors.integerExpected(errorMessage: "Integer was requested, but non-integer value found: '\(nextValue)' in row \(lineNumber)")
    }

    public func nextLine() -> String {

        var line = (try? readLine())!

        while !line.dropFirst().hasSuffix(quotes) {
            // Handle the special case of vvvvvvv"  00
            // i.e. a line with the terminating quote followed by a number.
            if line.dropFirst().contains(quotes) {
                break
            }

            let nextLine = (try? readLine())!
            line = line + "\n" + nextLine
        }

        return line.trimmingCharacters(in: [" ", "\"", "\n"])
    }

    public var numberOfLines: Int {
        return self.gameLines.count
    }

    public var currentLine: Int {
        return self.lineNumber
    }

    public func reset() {
        self.lineNumber = 0
    }

    public func nextLineIsNumeric() -> Bool {
        let line = gameLines[lineNumber]

        if Int(line) != nil {
            return true
        }
        return false
    }

    private func readLine() throws -> String {

        if lineNumber >= gameLines.count {
            throw GameDataReaderErrors.pastEndOfFile
        }

        let line = gameLines[lineNumber]
        lineNumber += 1

        return line.trimmingCharacters(in: [" "])
    }
}
