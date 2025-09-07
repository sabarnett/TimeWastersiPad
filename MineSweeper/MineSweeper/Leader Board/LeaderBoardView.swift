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

    @State var showConfirmation: Bool = false
    @State private var gameLevel: GameDifficulty = .beginner
    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .beginner:
            return leaderBoard.leaderBoard.beginnerLeaderBoard
                .sorted(by: {lhs, rhs in
                    return lhs.gameScore < rhs.gameScore
                })
        case .intermediate:
            return leaderBoard.leaderBoard.intermediateLeaderBoard
                .sorted(by: {lhs, rhs in
                    return lhs.gameScore < rhs.gameScore
                })
        case .expert:
            return leaderBoard.leaderBoard.expertLeaderBoard
                .sorted(by: {lhs, rhs in
                    return lhs.gameScore < rhs.gameScore
                })
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Leader Board")
                    .font(.title)
                Button(role: .destructive,
                       action: { showConfirmation = true },
                       label: { Image(systemName: "trash") })
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Image(systemName: "xmark.app").scaleEffect(1.8) })
            }

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
            }
            .listStyle(.plain)
            .alert(
                "Clear Leader Board?",
                isPresented: $showConfirmation,
                actions: {
                    Button(
                        role: .destructive,
                        action: { leaderBoard.clear() },
                           label: { Text("Yes")}
                    )
                    Button(
                        role: .cancel,
                        action: { },
                           label: { Text("No") }
                    )
                },
                message: {
                Text("Pressing Yes will clear all leader board history. Are you sure?")
            })
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
            Spacer()
            Text("\(leaderItem.gameScore)")
        }
    }
}
#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .expert)
}
