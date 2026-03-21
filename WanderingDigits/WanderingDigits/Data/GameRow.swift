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
class GameRow: CustomDebugStringConvertible {
    var debugDescription: String {
        values.joined(separator: ",")
    }
    
    /// Each element in the array represents a single digit in the number, as a string. Where
    /// the number is negative, the first character may be a minus sign.
    var values: [String] = []

    /// target represents the value of the numbers in the values array. This is useful for
    /// calculating whether the solution has been achieved.
    var target: Int {
        Int(self.values.joined()) ?? 0
    }

    /// The value here depends on the row we represent. It's a convenience for the display
    /// really. For the first row, it holds the operator to apply (+ or -). For the second row, it
    /// holds an = sign and for the third row, it is blank.
    private(set) var mathOperator: String

    // Helper variables to make accessing the data more intuitive
    var endIndex: Int { values.endIndex }
    var indices: Range<Int> { values.indices }
    
    /// Initialise a row. We need the list of numbers and, optionally, the math operator if this is
    /// the first row.
    ///
    /// - Parameters:
    ///   - values: An array of strings representing the numbers
    ///   - mathOperator: The math operator for the first row or an equals sign for the second.
    init(values: [String], mathOperator: String = " ") {
        self.mathOperator = mathOperator
        self.values = values
    }
    
    /// Returns the value from the row at a specific position. It's a convenience function.
    ///
    /// - Parameter index: The index of the item to fetch
    ///
    /// - Returns: The value from the row.
    func value(at index: Int) -> String {
        guard index >= 0 && index < values.count else {
            fatalError("Invalid value index \(index)")
        }
        return values[index]
    }
}
