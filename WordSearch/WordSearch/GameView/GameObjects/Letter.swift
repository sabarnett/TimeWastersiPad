//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 09/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class Letter: Identifiable {
    let id = UUID()

    var letter: Character
    var yPos: Int
    var xPos: Int
    var selected: Bool = false

    init(letter: Character, xPos: Int, yPos: Int) {
        self.letter = letter
        self.yPos = yPos
        self.xPos = xPos
        self.selected = false
    }
}
