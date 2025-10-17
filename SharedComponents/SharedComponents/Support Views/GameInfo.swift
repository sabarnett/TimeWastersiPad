//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct GameInfoView: View {

    @Environment(\.dismiss) private var dismiss
    private var gameData: GameDefinition

    public init(gameData: GameDefinition) {
        self.gameData = gameData
    }

    private var webSiteLink: URL? {
        guard let targetUrl = URL(string: gameData.link) else { return nil }
        return targetUrl
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
//                HStack {
//                    Text(gameData.title)
//                        .font(.title)
//                    Spacer()
//
//                }
                Text(gameData.tagLine).font(.title2)
                ScrollView {
                    Text(gameData.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text(gameData.credits)
                if let link = webSiteLink {
                    Link(destination: link) {
                        Text(gameData.link)
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle(gameData.title)
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
        }
        .padding()
    }
}

#Preview {
    GameInfoView(
        gameData: GameDefinition.example
    )
}
