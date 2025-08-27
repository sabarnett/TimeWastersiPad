//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 10/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct SnakeSettingsView: View {

    @AppStorage(Constants.snakePlaySounds) private var snakePlaySounds = true
    @AppStorage(Constants.snakeGameSpeed) private var snakeGameSpeed: SnakeGameSpeed = .medium
    @AppStorage(Constants.snakeGameSize) private var snakeGameSize: SnakeGameSize = .medium

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $snakePlaySounds)

            Picker("Game speed", selection: $snakeGameSpeed) {
                ForEach(SnakeGameSpeed.allCases) { speed in
                    Text(speed.description)
                        .tag(speed)
                }
            }

            Picker("Game board size", selection: $snakeGameSize) {
                ForEach(SnakeGameSize.allCases) { size in
                    Text(size.description)
                        .tag(size)
                }
            }
        }
    }
}

#Preview {
    SnakeSettingsView()
}
