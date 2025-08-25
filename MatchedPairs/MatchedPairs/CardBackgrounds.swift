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

enum CardBackgrounds: Int, Identifiable, CaseIterable {
    case one, two, three, four, five

    var id: Int { self.rawValue}

    var cardImage: String {
        switch self {
        case .one:
            return "back_01"
        case .two:
            return "back_02"
        case .three:
            return "back_03"
        case .four:
            return "back_04"
        case .five:
            return "back_05"
        }
    }

    var cardTitle: String {
        switch self {
        case .one:
            return "Black Maze"
        case .two:
            return "Red Maze"
        case .three:
            return "Brick Diamond"
        case .four:
            return "Moon"
        case .five:
            return "Stacked Stones"
        }
    }
}
