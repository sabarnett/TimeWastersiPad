//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 27/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TileView: View {
    @Binding var tile: PuzzleTile

    var onTap: (() -> Void)

    var body: some View {
        ZStack {
            Button(action: {
                onTap()
            }, label: {
                Text(tile.tileImage)
                    .font(.system(size: 60, weight: .bold))
                    .padding()
                    .frame(width: 90, height: 90)
                    .background(tile.tileColour.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))

                    .rotation3DEffect(.degrees(tile.isEmpty ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isEmpty ? 0 : 1)
                    .accessibility(hidden: tile.isEmpty)
            })
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                onTap()
            }, label: {
                Text(tile.tileImage)
                    .font(.system(size: 60, weight: .bold))
                    .padding()
                    .frame(width: 90, height: 90)
                    .background(tile.tileColour.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 25))

                    .rotation3DEffect(.degrees(tile.isEmpty ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    .opacity(tile.isEmpty ? 1 : -1)
                    .accessibility(hidden: !tile.isEmpty)
            })
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    TileView(tile: .constant(PuzzleTile.init(state: .empty))) {
    }
}
