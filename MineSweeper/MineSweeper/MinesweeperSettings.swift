//
// -----------------------------------------
// Original project: MineSweeper
// Original package: MineSweeper
// Created on: 17/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

enum GameDifficulty: Int, CaseIterable, Identifiable, CustomStringConvertible {
    case beginner
    case intermediate
    case expert

    var id: Self { self }

    var description: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .expert: return "Expert"
        }
    }
}

public struct MinesweeperSettings: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage(Constants.mineGameDifficulty) private var mineGameDifficulty: GameDifficulty = .beginner
    @AppStorage(Constants.minePlaySounds) private var minePlaySounds = true

    var showClose = false

    public init(showClose: Bool = false) {
        self.showClose = showClose
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Game Difficulty") {
                    Picker("Game difficulty", selection: $mineGameDifficulty) {
                        ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.description)
                                .tag(difficulty)
                        }
                    }

                    LabeledContent("") {
                        switch mineGameDifficulty {
                        case .beginner:
                            Text("9x9 Grid with 10 mines")
                        case .intermediate:
                            Text("16x16 Grid with 25 mines")
                        case .expert:
                            Text("22x22 Grid with 60 mines")
                        }
                    }
                }

                Section("Sounds") {
                    Toggle("Play Sounds", isOn: $minePlaySounds)
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
    MinesweeperSettings()
}
