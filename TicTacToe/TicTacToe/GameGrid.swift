//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 02/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameGrid: View {
    @ObservedObject var model = TicTacToeGameModel()

    let columns = [
        GridItem(.fixed(90.00), spacing: 10),
        GridItem(.fixed(90.00), spacing: 10),
        GridItem(.fixed(90.00), spacing: 10)]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach($model.gameBoard) { $tile in
                TileView(tile: $tile) {
                    if model.playersGo {
                        handleTileSelect(tile)
                    }
                }
            }
        }
    }

    /// Handle the player clicking a tile.
    ///
    /// - Parameter tile: The tile they clicked
    ///
    /// We want to set the tile to the players icon. However, we also need to
    /// ensure that the tileis empty, or we're reassigning a tile which is not
    /// allowed.
    ///
    /// Once the player tile has been set, we fire off the code to select the
    /// computers move. We can do this regardless of whether the game
    /// has been won or lost as the view model will deal with that situation.
    func handleTileSelect(_ tile: PuzzleTile) {
        withAnimation(.bouncy) {
            if model.setPlayerState(tile) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.bouncy) {
                        model.setComputerState()
                    }
                }
            }
        }
    }
}

#Preview {
    GameGrid()
}
