//
// -----------------------------------------
// Original project: Game2048
// Original package: Game2048
// Created on: 17/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: GameLevel

    @State var gameLevel: GameLevel = .four
    @State private var showConfirmation: Bool = false

    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .three:
            return leaderBoard.threeLeaderBoard
        case .four:
            return leaderBoard.fourLeaderBoard
        case .five:
            return leaderBoard.fiveLeaderBoard
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Picker("", selection: $gameLevel) {
                    pickerItem(.three)
                    pickerItem(.four)
                    pickerItem(.five)
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

    func pickerItem(_ difficulty: GameLevel) -> some View {
        Text(difficulty.description).tag(difficulty)
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .four)
}
