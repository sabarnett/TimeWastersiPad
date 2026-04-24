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
    @Environment(\.dismiss) private var dismiss

    @AppStorage(Constants.wordsearchPlaySounds)
    private var wordsearchPlaySounds = true

    @AppStorage(Constants.wordsearchAllowShowHints)
    private var allowShowHints = true

    @AppStorage(Constants.wordsearchDifficulty)
    private var gameDifficulty: Difficulty = .easy

    var showClose = false

    public init(showClose: Bool = false) {
        self.showClose = showClose
    }

    public var body: some View {
        NavigationStack {
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
    WordSearchSettingsView()
}
