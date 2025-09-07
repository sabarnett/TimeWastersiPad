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
    @State private var showConfirmation: Bool = false

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

    func pickerItem(_ difficulty: Difficulty) -> some View {
        Text(difficulty.shortDescription).tag(difficulty)
    }

    func headerView() -> some View {
        HStack {
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
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .easy)
}
