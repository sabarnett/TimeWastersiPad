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
        VStack(alignment: .leading) {
            headerView()

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
            }
        }
        .padding()
        .onAppear {
            gameLevel = initialTab
        }
    }

    func headerView() -> some View {
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

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .player)
}
