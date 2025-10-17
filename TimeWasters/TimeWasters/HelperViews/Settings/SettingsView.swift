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
    @Environment(\.colorScheme) private var colorScheme

    @AppStorage(Constants.displayMode) private var displayMode = DisplayMode.system

    @State private var displayStyle: ColorScheme?

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
            .preferredColorScheme(displayStyle)
        }
        .onAppear {
            displayStyle = displayMode.colorScheme
        }
        .onChange(of: displayMode) {
            // This is a massive fudge. When we change the color scheme,
            // the app will change but the settings sheet will not. This
            // is almost certainly a bug, but it is one that persists.
            //
            // To work round this, we trap the user changing the display
            // mode and set the preferred color scheme to be either
            // light or dark be the opposite of the current system
            // color scheme. It only affects this view while the
            // view is being displayed.
            if displayMode == .system {
                displayStyle = (colorScheme == .dark) ? .light : .dark
            } else {
                displayStyle = displayMode.colorScheme
            }
        }
    }
}

#Preview {
    SettingsView()
}
