//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 22/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: GameDifficulty

    @State var gameLevel: GameDifficulty = .easy

    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .easy:
            return leaderBoard.leaderBoard.easyLeaderBoard
        case .medium:
            return leaderBoard.leaderBoard.mediumLeaderBoard
        case .hard:
            return leaderBoard.leaderBoard.hardLeaderBoard
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            headerView()

            Picker("", selection: $gameLevel) {
                pickerItem(.easy)
                pickerItem(.medium)
                pickerItem(.hard)
            }
            .pickerStyle(SegmentedPickerStyle())

            List {
                LeaderBoardItemHeader()
                ForEach(leaderItems) { leaderItem in
                    LeaderBoardItemView(leaderItem: leaderItem)
                }
            }.frame(minHeight: 200)

            footerView()
        }
        .padding()
        .onAppear {
            gameLevel = initialTab
        }
    }

    func pickerItem(_ difficulty: GameDifficulty) -> some View {
        Text(difficulty.shortDescription).tag(difficulty)
    }

    func headerView() -> some View {
        HStack {
            Text("Leader Board")
                .font(.title)
            Spacer()
            Button(action: {
                leaderBoard.clearScores()
            }, label: {
                Image(systemName: "square.stack.3d.up.slash")
            })
            .buttonStyle(.plain)
            .help("Clear the leader board scores")
        }
    }

    func footerView() -> some View {
        HStack {
            Spacer()
            Button(role: .cancel,
                   action: { dismiss() },
                   label: { Text("Close") })
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .easy)
}
