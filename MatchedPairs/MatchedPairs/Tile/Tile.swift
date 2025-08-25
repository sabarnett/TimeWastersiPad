//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 20/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

struct Tile: Identifiable {
    let id = UUID()

    let face: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false

    mutating func match() {
        isFaceUp = false
        isMatched = true
    }
}
