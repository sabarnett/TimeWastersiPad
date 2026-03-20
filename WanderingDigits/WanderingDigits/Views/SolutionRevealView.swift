//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 20/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SolutionRevealView: View {
    @Environment(\.dismiss) private var dismiss

    let gameBoard: GameBoard
    let attempts: Int

    var body: some View {
        VStack {
            Text("Solution Reveal").font(.title).padding()

            Text("After ^[\(attempts) attempt](inflect: true), you have failed to fix the formula. You were looking for:")
                .font(.title2)
            Spacer()
            // TODO: Show the formula

            Group {
                LabeledContent("First Number", value: gameBoard.solution[0].values.joined())
                LabeledContent("Second Number", value: gameBoard.solution[1].values.joined())
                LabeledContent("Result", value: gameBoard.solution[2].values.joined())
            }
            .font(.numberFontSmall)
            .padding(.horizontal, 20)

            Spacer()

            Button("Play again") { dismiss() }
                .buttonStyle(.borderedProminent)
                .padding()
        }.padding()
    }
}

#Preview {
    SolutionRevealView(gameBoard: GameBoard(), attempts: 5)
}
