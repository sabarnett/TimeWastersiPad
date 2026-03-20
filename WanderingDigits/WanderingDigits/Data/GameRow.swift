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

    var values: [String] = []
    var target: Int {
        Int(self.values.joined()) ?? 0
    }

    private(set) var mathOperator: String

    // Helper variables to make accessing the data more intuitive
    var endIndex: Int { values.endIndex }
    var indices: Range<Int> { values.indices }

    init(values: [String], mathOperator: String = " ") {
        self.mathOperator = mathOperator
        self.values = values
    }

    func value(at index: Int) -> String {
        guard index >= 0 && index < values.count else {
            fatalError("Invalid value index \(index)")
        }
        return values[index]
    }
}
