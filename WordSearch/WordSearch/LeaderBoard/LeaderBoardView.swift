//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 04/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: Difficulty

    @State var gameLevel: Difficulty = .easy

    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .easy:
            return leaderBoard.easyLeaderBoard
        case .medium:
            return leaderBoard.mediumLeaderBoard
        case .hard:
            return leaderBoard.hardLeaderBoard
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

    func pickerItem(_ difficulty: Difficulty) -> some View {
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
