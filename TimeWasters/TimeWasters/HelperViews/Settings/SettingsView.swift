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
    @AppStorage(Constants.darkMode) var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: {
                    GeneralSettingsView()
                }, label: {
                    Label("General", systemImage: "gearshape")
                        .font(.title3)
                        .padding(.vertical, 4)
                })
                ForEach(Game.allCases, id: \.self) { game in
                    if game.gameDefinition.settingsIcon != nil {
                        NavigationLink(destination: {
                            Text(game.gameDefinition.description)
//                            game.settingsView
                        }, label: {
                            Label(game.gameDefinition.title,
                                  systemImage: game.gameDefinition.settingsIcon!)
                        })
                        .font(.title3)
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
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    SettingsView()
}
