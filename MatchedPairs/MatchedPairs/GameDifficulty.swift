//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 18/02/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

enum GameDifficulty: String, Identifiable, CaseIterable, CustomStringConvertible {
    case easy
    case medium
    case hard
    
    var id: GameDifficulty { self }
    
    var description: String {
        switch self {
        case .easy:
            return "Easy (6 columns, 4 rows)"
        case .medium:
            return "Medium (8 columns, 5 rows)"
        case .hard:
            return "Hard (10 columns, 6 rows)"
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

    var columns: Int {
        switch self {
        case .easy:
            return 6
        case .medium:
            return 8
        case .hard:
            return 10
        }
    }
    
    var rows: Int {
        switch self {
        case .easy:
            return 4
        case .medium:
            return 5
        case .hard:
            return 6
        }
    }
}
