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

struct TileView: View {

    @Binding var tile: Tile
    var pieceSize: CGFloat

    var onTap: (() -> Void)

    var body: some View {
        ZStack {
            Button(action: {
                if tile.state == .potentialPlayerMove {
                    onTap()
                }
            }, label: {
                Image(systemName: Constants.gamePieceSystemImage)
                    .resizable()
                    .padding(8)
                    .frame(width: pieceSize, height: pieceSize)
                    .foregroundStyle(tile.foregroundColor)
                    .background(tile.backgroundColor.gradient)

                    .rotation3DEffect(.degrees(tile.isEmpty ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isEmpty ? 0 : 1)
                    .accessibility(hidden: tile.isEmpty)
            })
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                onTap()
            }, label: {
                Image(systemName: Constants.gamePieceSystemImage)
                    .resizable()
                    .padding(6)
                    .frame(width: pieceSize, height: pieceSize)
                    .foregroundStyle(tile.foregroundColor)
                    .background(tile.backgroundColor.gradient)
                    .rotation3DEffect(.degrees(tile.isEmpty ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isEmpty ? 1 : -1)
                    .accessibility(hidden: !tile.isEmpty)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    TileView(tile: .constant(Tile()), pieceSize: 56.0) {
        print("Tile tapped")
    }
}
