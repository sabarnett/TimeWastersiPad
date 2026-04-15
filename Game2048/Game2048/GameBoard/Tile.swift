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

import SwiftUI

// MARK: - Tile

struct Tile: Identifiable, Equatable {
    let id: UUID
    var value: Int
    var row: Int
    var col: Int
    var isNew: Bool = false
    var isMerged: Bool = false

    init(value: Int, row: Int, col: Int) {
        self.id = UUID()
        self.value = value
        self.row = row
        self.col = col
    }

    var color: Color {
        switch value {
        case 2:    return Color(red: 0.93, green: 0.89, blue: 0.85)
        case 4:    return Color(red: 0.93, green: 0.87, blue: 0.78)
        case 8:    return Color(red: 0.95, green: 0.69, blue: 0.47)
        case 16:   return Color(red: 0.96, green: 0.58, blue: 0.39)
        case 32:   return Color(red: 0.96, green: 0.49, blue: 0.37)
        case 64:   return Color(red: 0.96, green: 0.37, blue: 0.23)
        case 128:  return Color(red: 0.93, green: 0.81, blue: 0.45)
        case 256:  return Color(red: 0.93, green: 0.80, blue: 0.38)
        case 512:  return Color(red: 0.93, green: 0.78, blue: 0.31)
        case 1024: return Color(red: 0.93, green: 0.76, blue: 0.25)
        case 2048: return Color(red: 0.93, green: 0.73, blue: 0.18)
        default:   return Color(red: 0.24, green: 0.22, blue: 0.20)
        }
    }

    var textColor: Color {
        value <= 4 ? Color(red: 0.47, green: 0.43, blue: 0.40) : .white
    }
}

// MARK: - Move Direction

enum MoveDirection {
    case up, down, left, right
}

// MARK: - Game State

enum GameState {
    case playing, won, lost
}
