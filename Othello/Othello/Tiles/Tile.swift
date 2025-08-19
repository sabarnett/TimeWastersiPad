//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 18/12/2024 by: Steven Barnett
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
    case potentialPlayerMove
}

class Tile: Identifiable, ObservableObject {
    let id = UUID()

    static func == (lhs: Tile, rhs: Tile) -> Bool {
        lhs.id == rhs.id
    }

    @Published var state: TileState = .empty

    var foregroundColor: Color {
        switch state {
        case .empty: return Color.clear
        case .player: return Constants.playerColor
        case .computer: return Constants.computerColor
        case .potentialPlayerMove: return Constants.playerColor
        }
    }

    var backgroundColor: Color {
        switch state {
        case .empty: return Color.gray
        case .player: return Color.gray
        case .computer: return Color.gray
        case .potentialPlayerMove: return Color.green
        }
    }

    var isEmpty: Bool {
        self.state == .empty
    }
}
