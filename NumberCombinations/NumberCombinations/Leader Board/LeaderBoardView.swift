//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 10/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    @State var showConfirmation: Bool = false

    let leaderBoard: LeaderBoard

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    LeaderBoardItemHeader()
                    ForEach(leaderBoard.leaderBoard.gameTimes) { leaderItem in
                        LeaderBoardItemView(leaderItem: leaderItem)
                    }
                }
                .navigationTitle("Leader Board")
                .navigationBarTitleDisplayMode(.inline)
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
    LeaderBoardView(leaderBoard: LeaderBoard())
}
