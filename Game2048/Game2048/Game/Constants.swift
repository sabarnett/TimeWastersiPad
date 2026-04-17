//
// -----------------------------------------
// Original project: 2048
// Original package: 2048
// Created on: 13/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import Foundation

enum GameLevel: Int, CaseIterable, Identifiable, CustomStringConvertible {
    case three = 3
    case four = 4
    case five = 5

    var id: Int { self.rawValue }

    var description: String {
        switch self {
        case .three:
            "3x3"
        case .four:
            "4x4"
        case .five:
            "5x5"
        }
    }
}

struct Constants {
    static let gameGridSize: Int = 4

    static let gridSize: String = "g2048GridSize"
    static let playSounds: String = "g2048PlaySounds"
    static let leaderBoardFileName: String = "game2048LeaderBoard"
}
