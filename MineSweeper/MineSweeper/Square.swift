//
//  Square.swift
//  Minesweeper
//
//  Created by Paul Hudson on 03/08/2024.
//

import Foundation

@Observable
class Square: Equatable, Identifiable {
    var id = UUID()
    var row: Int
    var column: Int

    var hasMine = false
    var nearbyMines = 0
    var isRevealed = false
    var isFlagged = false

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    static func == (lhs: Square, rhs: Square) -> Bool {
        lhs.id == rhs.id
    }
}
