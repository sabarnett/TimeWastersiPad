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

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .system

    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: {
                    GeneralSettingsView()
                }, label: {
                    Label("General", systemImage: "gearshape")
                        .padding(.vertical, 4)
                        .foregroundStyle(.primary)
                })
                ForEach(Game.allCases, id: \.self) { game in
                    if game.gameDefinition.hasSettings {
                        NavigationLink(destination: {
                            GameViewFactory().settingsView(for: game)
                        }, label: {
                            Label(game.gameDefinition.title,
                                  systemImage: game.gameDefinition.gameIcon)
                            .foregroundStyle(.primary)
                        })
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Game Settings")
            .toolbar {
                Button(role: .cancel,
                       action: { dismiss() },
                       label: { Image(systemName: "xmark.app").scaleEffect(1.3) })
            }
            .preferredColorScheme(displayMode.colorScheme)
        }
    }
}

#Preview {
    SettingsView()
}
