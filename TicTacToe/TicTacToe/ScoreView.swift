//
// -----------------------------------------
// Original project: TicTacToe
// Original package: TicTacToe
// Created on: 30/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ScoreView: View {

    @State var model: TicTacToeGameModel

    var body: some View {
        List {
            scoreItem(title: "😀 Player Wins",
                      score: model.playerWins)
            scoreItem(title: "🤖 Computer Wins",
                      score: model.computerWins)
            scoreItem(title: "🤲 Draws",
                      score: model.draws)

            // This is a fudge. None of the score properties are observed, so the
            // view does not update when they change. By including the game state,
            // we will refresh this view when the model changes.
            Text("\(model.gameState.description)")
                .opacity(0)

        }.listStyle(.plain)
    }

    private func scoreItem(title: String, score: Int) -> some View {
        Section(content: {
            Text(score.formatted(.number))
                .font(.system(size: 26))
                .padding(.horizontal, 8)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
        }, header: {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .listSectionSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 8)
                .background {
                    Color.accentColor.opacity(0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
        })
        .listSectionSeparator(.hidden)
    }
}

#Preview {
    ScoreView(model: TicTacToeGameModel())
}
