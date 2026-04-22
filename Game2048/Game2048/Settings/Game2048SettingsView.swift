//
// -----------------------------------------
// Original project: Game2048
// Original package: Game2048
// Created on: 21/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//


import SwiftUI

public struct Game2048SettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage(Constants.playSounds) private var playSounds = true
    @AppStorage(Constants.gameLevel) private var gameLevel: GameLevel = .four

    public var showClose: Bool = false

    public init(showClose: Bool = false) {
        self.showClose = showClose
    }

    public var body: some View {
        NavigationStack {
            Form {
                Toggle("Play sounds", isOn: $playSounds)

                Picker("Game level", selection: $gameLevel) {
                    ForEach(GameLevel.allCases) { level in
                        Text(level.description)
                            .tag(level)
                    }
                }
            }
            .toolbar {
                if showClose {
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
        }
    }
}

#Preview {
    Game2048SettingsView()
}
