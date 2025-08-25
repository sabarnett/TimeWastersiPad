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

import SwiftUI

struct Constants {
    static let tileSize: CGFloat = 46
    static let tileCountPerRow: Int = 14
    static let wordListWidth: CGFloat = 200

    static let wordCount: Int = 14
    static let cellSpacing: CGFloat = 2
    static let selectedLineWidth: CGFloat = tileSize * 0.7
    static let selectedLineColor: Color = .green.opacity(0.3)

    static let leaderBoardFileName: String = "wordSearchLeaderBoard"

    static let wordsearchPlaySounds: String = "wordsearchPlaySounds"
    static let wordsearchAllowShowHints: String = "wordsearchAllowShowHints"
    static let wordsearchDifficulty: String = "wordsearchDifficulty"

    static let oed: String = "https://www.oed.com/search/dictionary/?scope=Entries&q="
}
