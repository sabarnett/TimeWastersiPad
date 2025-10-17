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

import SharedComponents
import SwiftUI

struct GameItemButtonView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Namespace var animation
    @State private var showInfoFor: Game?
    var game: Game

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: game.gameDefinition.gameIcon)
                    Text(game.gameDefinition.title)
                        .font(.callout)
                        .bold()
                }
            }
            Spacer()
            if #available(iOS 26.0, *) {
                Button("", systemImage: "info.circle") {
                    showInfoFor = game
                }
                .glassEffect()
                .matchedTransitionSource(id: "showInfo", in: animation)
            } else {
                Button("", systemImage: "info.circle") {
                    showInfoFor = game
                }
                .matchedTransitionSource(id: "showInfo", in: animation)
            }
        }
        .foregroundStyle(.primary)
        .sheet(item: $showInfoFor) { game in
            GameInfoView(gameData: game.gameDefinition)
                .navigationTransition(.zoom(sourceID: "showInfo", in: animation))
        }
    }
}

#Preview {
    GameItemButtonView(game: Game.adventure)
}
