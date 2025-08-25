//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 10/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct WordSearchSettingsView: View {

    @AppStorage(Constants.wordsearchPlaySounds)
    private var wordsearchPlaySounds = true

    @AppStorage(Constants.wordsearchAllowShowHints)
    private var allowShowHints = true

    @AppStorage(Constants.wordsearchDifficulty)
    private var gameDifficulty: Difficulty = .easy

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $wordsearchPlaySounds)
                .padding(.bottom, 8)
            Toggle("Allow hints", isOn: $allowShowHints)
                .padding(.bottom, 8)

            Picker("Game difficulty", selection: $gameDifficulty) {
                ForEach(Difficulty.allCases) { level in
                    Text(level.description)
                        .tag(level)
                }
            }
        }
    }
}

#Preview {
    WordSearchSettingsView()
}
