//
// -----------------------------------------
// Original project: MineSweeper
// Original package: MineSweeper
// Created on: 09/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: GameDifficulty

    @State private var gameLevel: GameDifficulty = .beginner
    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .beginner:
            return leaderBoard.leaderBoard.beginnerLeaderBoard
        case .intermediate:
            return leaderBoard.leaderBoard.intermediateLeaderBoard
        case .expert:
            return leaderBoard.leaderBoard.expertLeaderBoard
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Leader Board").font(.title)

            Picker("", selection: $gameLevel) {
                Text("Beginner").tag(GameDifficulty.beginner)
                Text("Imtermediate").tag(GameDifficulty.intermediate)
                Text("Expert").tag(GameDifficulty.expert)
            }
            .pickerStyle(SegmentedPickerStyle())

            List {
                LeaderBoardItemHeader()
                ForEach(leaderItems) { leaderItem in
                    LeaderBoardItemView(leaderItem: leaderItem)
                }
            }.frame(minHeight: 200)

            HStack {
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Text("Close") })
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
        }
        .padding()
        .onAppear {
            gameLevel = initialTab
        }
    }
}

struct LeaderBoardItemHeader: View {
    var body: some View {
        HStack {
            Text("Date")
                .font(.headline)
                .frame(minWidth: 160, maxWidth: 160, alignment: .leading)
            Text("Player")
                .font(.headline)
            Spacer()
            Text("Seconds")
                .font(.headline)
        }.foregroundStyle(.orange.opacity(0.85))
    }
}

struct LeaderBoardItemView: View {
    var leaderItem: LeaderBoardItem
    let dateFormatter: DateFormatter

    init(leaderItem: LeaderBoardItem) {
        self.leaderItem = leaderItem
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }

    var body: some View {
        HStack {
            Text(dateFormatter.string(from: leaderItem.gameDate))
                .frame(minWidth: 160, maxWidth: 160, alignment: .leading)
            Text(leaderItem.playerName)
            Spacer()
            Text("\(leaderItem.gameScore)")
        }
    }
}
#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .expert)
}
