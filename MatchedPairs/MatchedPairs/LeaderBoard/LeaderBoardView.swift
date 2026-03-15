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
    @State private var showConfirmation: Bool = false

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
        NavigationStack {
            VStack(alignment: .leading) {
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
                .navigationTitle("Leader Board")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if #available(iOS 26.0, *) {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .destructive,
                                   action: { showConfirmation = true },
                                   label: { Image(systemName: "trash") })
                            .tint(.red)
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .close,
                                   action: { dismiss() }
                            )
                        }
                    } else {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(role: .destructive,
                                   action: { showConfirmation = true },
                                   label: { Image(systemName: "trash") })
                            .tint(.red)
                        }

                        ToolbarItem(placement: .topBarTrailing) {
                            Button(role: .cancel,
                                   action: { dismiss() },
                                   label: { Image(systemName: "xmark.app").scaleEffect(1.3) }
                            )
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                gameLevel = initialTab
            }
        }
    }

    func pickerItem(_ difficulty: GameDifficulty) -> some View {
        Text(difficulty.shortDescription).tag(difficulty)
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .easy)
}
