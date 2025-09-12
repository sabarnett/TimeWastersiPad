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

struct ScoresView: View {

    @ObservedObject var model: OthelloViewModel

    var body: some View {
        List {
            scoreItem(
                title: "Player Score",
                color: Constants.playerColor,
                score: model.playerScore
            )

            scoreItem(
                title: "Computer Score",
                color: Constants.computerColor,
                score: model.computerScore
            )
        }
    }

    private func scoreItem(title: String, color: Color, score: Int) -> some View {
        Section(content: {
            Text(score.formatted(.number))
                .font(.system(size: 26))
                .padding(.horizontal, 6)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
        }, header: {
            HStack {
                Image(systemName: Constants.gamePieceSystemImage)
                    .foregroundStyle(color)
                Text(title)
            }
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
    ScoresView(model: OthelloViewModel())
}
