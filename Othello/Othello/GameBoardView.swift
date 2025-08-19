//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 22/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {

    @ObservedObject var model: OthelloViewModel

    var body: some View {
            HStack {
                ForEach(0..<model.gameBoard.count, id: \.self) { idx in
                    let column = $model.gameBoard[idx]

                    VStack(spacing: 2) {
                        ForEach(column) { $tile in
                            TileView(tile: $tile) {
                                playersMove(tile)
                            }
                        }
                    }
                }
            }
            .onChange(of: model.gameState) { _, new in
                // If the player has no valid moves, the computer
                // moves again.
                if new == .noValidMove {
                    model.computerMove()
                }
            }
    }

    private func playersMove(_ tile: Tile) {
        guard model.gameState == .playerMove else { return }
        let thinkingTime = Double.random(in: 0.7...2.0)
        withAnimation {
            if model.select(tile: tile) {
                DispatchQueue.main.asyncAfter(deadline: .now() + thinkingTime) {
                    withAnimation(.bouncy) {
                        model.computerMove()
                    }
                }
            }
        }
    }
}

#Preview {
    GameBoardView(model: OthelloViewModel())
}
