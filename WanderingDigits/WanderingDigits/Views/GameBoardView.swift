//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 18/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {

    @Bindable var game: WanderingDigitsGame

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(game.gameBoard.rows.indices, id: \.self) { arrayIndex in
                ArrayRowView(
                    arrayIndex: arrayIndex,
                    board: $game.gameBoard,
                    checkResult: game.checkMove
                )
            }
        }
        .padding()
    }

}
