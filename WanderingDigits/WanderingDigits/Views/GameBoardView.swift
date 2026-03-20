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

    @Bindable var gameBoard: GameBoard
    let checkResult: (String, Int, Int, Int, Int) -> Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(gameBoard.rows.indices, id: \.self) { arrayIndex in
                ArrayRowView(
                    arrayIndex: arrayIndex,
                    board: gameBoard,
                    checkResult: checkResult
                )
            }
        }
        .padding()
    }

}
