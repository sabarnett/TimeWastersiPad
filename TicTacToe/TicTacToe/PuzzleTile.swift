//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 30/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum TileState {
    case empty
    case player
    case computer
}

@Observable
class PuzzleTile: Identifiable {
    var id: UUID = UUID()
    var state: TileState

    init(state: TileState) {
        self.state = state
    }

    var tileColour: Color {
        switch state {
        case .empty:
            return Color.blue
        case .player:
            return Color.green
        case .computer:
            return Color.cyan
        }
    }

    var tileImage: String {
        switch self.state {
        case .empty:
            " "
        case .player:
            "😀"
        case .computer:
            "🤖"
        }
    }

    var isEmpty: Bool {
        self.state == .empty
    }

    func setState(state: TileState) {
        self.state = state
        print("Changing state")
    }
}
