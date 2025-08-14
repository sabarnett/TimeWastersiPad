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
        VStack(alignment: .leading) {
            HStack {
                Text(gameData.title)
                    .font(.title)
                Spacer()
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Image(systemName: "xmark.app").scaleEffect(1.8) })
            }
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
        .padding()
    }
}

#Preview {
    GameInfoView(
        gameData: GameDefinition.example
    )
}
