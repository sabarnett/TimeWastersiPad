//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 10/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: SnakeGameSize

    @State var gameLevel: SnakeGameSize = .small
    @State private var showConfirmation: Bool = false

    var leaderItems: [LeaderBoardItem] {
        switch gameLevel {
        case .small:
            return leaderBoard.leaderBoard.smallLeaderBoard
        case .medium:
            return leaderBoard.leaderBoard.mediumLeaderBoard
        case .large:
            return leaderBoard.leaderBoard.largeLeaderBoard
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Picker("", selection: $gameLevel) {
                    Text("Small").tag(SnakeGameSize.small)
                    Text("Medium").tag(SnakeGameSize.medium)
                    Text("Large").tag(SnakeGameSize.large)
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
}

struct LeaderBoardItemHeader: View {
    var body: some View {
        HStack {
            Text("Date")
                .font(.headline)
            Spacer()
            Text("Size")
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
                    initialTab: .large)
}
