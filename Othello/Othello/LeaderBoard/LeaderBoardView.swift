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
                }.frame(minHeight: 200)
            }

            footerView()
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
            Spacer()
            Button(action: {
                leaderBoard.clearScores()
            }, label: {
                Image(systemName: "square.stack.3d.up.slash.fill")
            })
            .buttonStyle(.plain)
            .help("Clear the leader board scores")
        }
    }

    func footerView() -> some View {
        HStack {
            Spacer()
            Button(role: .cancel,
                   action: { dismiss() },
                   label: { Text("Close") })
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
        }
    }
}

#Preview {
    LeaderBoardView(leaderBoard: LeaderBoard(),
                    initialTab: .player)
}
