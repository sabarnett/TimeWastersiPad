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

    @Environment(MatchedPairsGameModel.self) var model
    @State private var showDelay: CGFloat = 0

    var onSelect: (Tile) -> Void

    var gamePlayColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(85.00), spacing: 3), count: model.columns)
    }

    var body: some View {
        LazyVGrid(columns: gamePlayColumns) {
            ForEach(model.tiles) { tile in
                TileView(tile: tile) {
                    onSelect(tile)
                }
                .environment(model)
            }
        }

    }
}

#Preview {
    GameGridView { _ in }
        .environment(MatchedPairsGameModel())
}
