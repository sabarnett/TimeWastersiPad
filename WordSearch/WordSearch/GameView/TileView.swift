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
    private var backgroundColour: Color {
        if tile.selected {
            return .blue.opacity(0.6)
        }

        return colorScheme == .dark ? .white.opacity(0.8) : .gray.opacity(0.2)
    }

    private var foregroundColour: Color {
        tile.selected ? .white : .black
    }

    var body: some View {
        Text(String(tile.letter).uppercased())
            .font(.system(size: 24))
            .fontDesign(.rounded)
            .frame(width: Constants.tileSize, height: Constants.tileSize)
            .foregroundStyle(foregroundColour)
            .background(backgroundColour)
    }
}
