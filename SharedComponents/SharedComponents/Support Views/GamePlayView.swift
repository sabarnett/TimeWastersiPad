//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 14/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct GamePlayView: View {
    @Environment(\.dismiss) private var dismiss

    private var game: GameDefinition

    public init(game: GameDefinition) {
        self.game = game
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(game.tagLine).font(.subheadline)
                ScrollView {
                    Text(game.gamePlay)
                }
                .toolbar {
                    ToolbarItem {
                        if #available(iOS 26.0, *) {
                            Button(role: .close,
                                   action: { dismiss() }
                            )
                            .glassEffect()
                        } else {
                            Button(role: .cancel,
                                   action: { dismiss() },
                                   label: { Image(systemName: "xmark.app").scaleEffect(1.3) }
                            )
                        }
                    }
                }
                .navigationTitle(game.title)
            }
        }
        .padding()
    }
}

#Preview {
    GamePlayView(game: Game.adventure.gameDefinition)
}
