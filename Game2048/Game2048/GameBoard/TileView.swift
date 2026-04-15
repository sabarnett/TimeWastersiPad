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

struct TileView: View {
    let tile: Tile
    let tileSize: CGFloat

    @State private var scale: CGFloat = 1.0
    @State private var appeared = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(tile.color)
                .shadow(color: tile.color.opacity(0.4), radius: 6, x: 0, y: 3)

            Text(tile.value >= 1000
                 ? tile.value >= 10000
                    ? "\(tile.value / 1000)K"
                    : "\(tile.value)"
                 : "\(tile.value)")
                .font(.system(size: fontSize, weight: .black, design: .rounded))
                .foregroundStyle(tile.textColor)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(8)
        }
        .frame(width: tileSize, height: tileSize)
        .scaleEffect(scale)
        .onAppear {
            if tile.isNew {
                scale = 0.1
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
        }
    }

    private var fontSize: CGFloat {
        switch tile.value {
        case ..<100:   return tileSize * 0.40
        case ..<1000:  return tileSize * 0.34
        case ..<10000: return tileSize * 0.28
        default:       return tileSize * 0.22
        }
    }
}
