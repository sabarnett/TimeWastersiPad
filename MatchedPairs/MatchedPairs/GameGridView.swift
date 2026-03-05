//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 27/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameGridView: View {

    @Bindable var model: MatchedPairsGameModel
    @State private var showDelay: CGFloat = 0

    var gridItemWidth: CGFloat
    var onSelect: (Tile) -> Void

    var gamePlayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth), spacing: 3), count: model.columns)
    }

    var body: some View {
        LazyVGrid(columns: gamePlayColumns) {
            ForEach(model.tiles) { tile in
                TileView(model: model, tile: tile, cardWidth: gridItemWidth - 5.0) {
                    onSelect(tile)
                }
            }
        }

    }
}

#Preview {
    GameGridView(model: MatchedPairsGameModel(), gridItemWidth: 85.0) { _ in }
}
