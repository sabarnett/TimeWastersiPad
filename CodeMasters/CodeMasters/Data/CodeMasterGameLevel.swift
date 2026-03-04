//
// -----------------------------------------
// Original project: CodeMasters
// Original package: CodeMasters
// Created on: 04/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import Foundation

enum CodeMasterGameLevel: String, Identifiable, CaseIterable, CustomStringConvertible  {
    case random, easy, medium, hard, veryhard

    var id: String { rawValue }

    var description: String {
        switch self {
        case .random: return "Random"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .veryhard: return "Very Hard"
        }
    }

    static var randomLevel: CodeMasterGameLevel {
        while(true) {
            if let randomLevel = CodeMasterGameLevel.allCases.randomElement(),
               randomLevel != .random {
                return randomLevel
            }
        }
    }

    var pegCount: Int {
        switch self {
        case .random:
            Int.random(in: 3...6)
        case .easy:
            3
        case .medium:
            4
        case .hard:
            5
        case .veryhard:
            6
        }
    }
}
