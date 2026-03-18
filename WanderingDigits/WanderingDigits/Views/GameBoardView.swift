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
        HStack(alignment: .top, spacing: 16) {
            ForEach(game.gameBoard.indices, id: \.self) { arrayIndex in
                ArrayColumnView(
                    arrayIndex: arrayIndex,
                    arrays: $game.gameBoard,
                    checkResult: checkResult
                )
            }
        }
        .padding()
    }

    // MARK: - Result Check
    func checkResult(
        item: String,
        fromArray: Int, fromIndex: Int,
        toArray: Int, toIndex: Int
    ) -> Bool {
        // Replace with your actual logic.
        return true
    }
}
