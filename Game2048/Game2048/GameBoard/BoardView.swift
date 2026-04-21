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

struct BoardView: View {
    let model: GameModel
    let boardSize: CGFloat

    private var gridSize: Int {
        model.gameLevel.gridSize
    }
    private let gap: CGFloat = 12

    private var tileSize: CGFloat {
        (boardSize - gap * CGFloat(gridSize + 1)) / CGFloat(gridSize)
    }

    var body: some View {
        ZStack {
            // Background grid cells
            VStack(spacing: gap) {
                ForEach(0..<gridSize, id: \.self) { _ in
                    HStack(spacing: gap) {
                        ForEach(0..<gridSize, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.80, green: 0.75, blue: 0.70).opacity(0.5))
                                .frame(width: tileSize, height: tileSize)
                        }
                    }
                }
            }
            .padding(gap)

            // Live tiles
            ForEach(model.tiles) { tile in
                TileView(tile: tile, tileSize: tileSize)
                    .position(position(for: tile))
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: tile.row)
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: tile.col)
            }
        }
        .frame(width: boardSize, height: boardSize)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.72, green: 0.67, blue: 0.63))
                .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
        )
    }

    private func position(for tile: Tile) -> CGPoint {
        let x = gap + tileSize * CGFloat(tile.col) + gap * CGFloat(tile.col) + tileSize / 2
        let y = gap + tileSize * CGFloat(tile.row) + gap * CGFloat(tile.row) + tileSize / 2
        return CGPoint(x: x, y: y)
    }
}
