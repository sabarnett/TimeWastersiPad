//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 17/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard

    @State var showConfirmation: Bool = false

    var leaderItems: [LeaderBoardItem] {
        return leaderBoard.leaderBoard.leaderBoard
            .sorted(by: {lhs, rhs in
                return lhs.gameScore < rhs.gameScore
            })
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
                .frame(width: 95, alignment: .trailing)

            Text("Attempts")
                .font(.headline)
                .frame(width: 95, alignment: .trailing)
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
                .frame(width: 95, alignment: .trailing)
            Text("\(leaderItem.gameAttempts)")
                .frame(width: 95, alignment: .trailing)
        }
    }
}
#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard())
}
