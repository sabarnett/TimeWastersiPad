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
class MatchedWord: Identifiable {
    let id = UUID()

    var startY: Int
    var startX: Int

    var endY: Int
    var endX: Int

    init(startX: Int, startY: Int, endX: Int, endY: Int) {
        self.startY = startY
        self.startX = startX
        self.endY = endY
        self.endX = endX
    }

    init(startLetter: Letter, endLetter: Letter) {
        self.startY = startLetter.yPos
        self.startX = startLetter.xPos
        self.endY = endLetter.yPos
        self.endX = endLetter.xPos
    }
}
