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

    @AppStorage(Constants.playSounds) private var playSounds = true
    @AppStorage(Constants.gameLevel) private var gameLevel: GameLevel = .four

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)

            Picker("Game level", selection: $gameLevel) {
                ForEach(GameLevel.allCases) { level in
                    Text(level.description)
                        .tag(level)
                }
            }
        }
    }
}

#Preview {
    Game2048SettingsView()
}
