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

struct TileView: View {

    @Environment(\.colorScheme) private var colorScheme

    var tile: Letter
    var cellSize: CGFloat
    var fontSize: CGFloat

    private var backgroundColour: Color {
        if tile.selected {
            return .blue.opacity(0.6)
        }

        return colorScheme == .dark ? .white.opacity(0.8) : .gray.opacity(0.2)
    }

    private var foregroundColour: Color {
        print("Tile size: \(Constants.tileSize), fontSize: 24")
        return tile.selected ? .white : .black
    }

    var body: some View {
        Text(String(tile.letter).uppercased())
            .font(.system(size: fontSize))
            .fontDesign(.rounded)
            .frame(width: cellSize, height: cellSize)
            .foregroundStyle(foregroundColour)
            .background(backgroundColour)
    }
}
