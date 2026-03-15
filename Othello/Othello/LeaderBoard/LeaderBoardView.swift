//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 31/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardView: View {
    @Environment(\.dismiss) private var dismiss

    let leaderBoard: LeaderBoard
    let initialTab: LeaderBoardScoreFor

    @State var gameLevel: LeaderBoardScoreFor = .player
    @State var showConfirmation: Bool = false

    var leaderItems: [LeaderBoardItem] {
        leaderBoard
            .allLeaderBoard
            .sorted(by: { $0.gameScore > $1.gameScore })
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
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
            }
            .padding()
            .onAppear {
                gameLevel = initialTab
            }
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .player)
}
