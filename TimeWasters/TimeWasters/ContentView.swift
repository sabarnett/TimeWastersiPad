//
// -----------------------------------------
// Original project: TimeWasters
// Original package: TimeWasters
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

struct ContentView: View {
    @State private var selectedGame: Game?
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility,
        sidebar: {
            GameMenuView(selectedGame: $selectedGame)
                .navigationTitle("")
                .padding()
        }, detail: {
            if selectedGame == nil {
                ContentUnavailableView("Select a Game",
                                       systemImage: "gamecontroller",
                                       description: Text("Select a game from the list in the side bar"))
            } else {
                GameView(game: $selectedGame)
                    .navigationTitle(selectedGame!.gameDefinition.title)
            }
        })
        .onChange(of: selectedGame) {
            columnVisibility = selectedGame == nil
            ? .automatic
            : .detailOnly
        }
    }
}

#Preview {
    ContentView()
}
