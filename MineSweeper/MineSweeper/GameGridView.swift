//
// -----------------------------------------
// Original project: MineSweeper
// Original package: MineSweeper
// Created on: 04/09/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameGridView: View {
    @State var game: MinesweeperGame

    var body: some View {
        GeometryReader { proxy in
            let minSize = proxy.size.width > proxy.size.height
            ? proxy.size.height
            : proxy.size.width

            let squareSize = minSize / (CGFloat(game.rows.count + 2))

            HStack(alignment: .center) {
                Spacer()
                Grid(horizontalSpacing: 2, verticalSpacing: 2) {
                    ForEach(0..<game.rows.count, id: \.self) { row in
                        GridRow {
                            ForEach(game.rows[row]) { square in
                                SquareView(square: square, cellSize: squareSize)
                                    .onTapGesture {
                                        game.select(square)
                                    }
                                    .onLongPressGesture {
                                        game.flag(square)
                                    }
                            }
                        }
                    }
                }
                Spacer()
            }
            .font(.largeTitle)
            .onAppear(perform: game.createGrid)
            .clipShape(.rect(cornerRadius: 6))
            .padding([.horizontal, .bottom])
            .opacity(game.isWaiting || game.isPlaying ? 1 : 0.5)
        }
    }
}

#Preview {
    GameGridView(game: MinesweeperGame())
}
