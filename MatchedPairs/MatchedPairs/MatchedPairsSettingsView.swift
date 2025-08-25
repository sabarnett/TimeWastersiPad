//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 22/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct MatchedPairsSettingsView: View {

    // Images need to be loaded from the current bundle, not the global one
    let myBundle = Bundle(for: MatchedPairsGameModel.self)

    @AppStorage(Constants.playSound) private var playSounds = true
    @AppStorage(Constants.gameDifficulty) private var gameDifficulty: GameDifficulty = .easy
    @AppStorage(Constants.cardBackground) private var cardBackground: CardBackgrounds = .one

    @AppStorage(Constants.autoFlip) private var autoFlip: Bool = false
    @AppStorage(Constants.autoFlipDelay) private var autoFlipDelay: Double = 5

    @State private var bgID: Int? = 0

    var formattedDelay: String {
        autoFlipDelay.formatted(.number.precision(.integerLength(2)))
    }

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)
                .padding(.bottom, 8)

            Picker("Game difficulty", selection: $gameDifficulty) {
                ForEach(GameDifficulty.allCases) { difficulty in
                    Text(difficulty.description)
                        .tag(difficulty)
                }
            }
            .padding(.bottom, 8)

            Toggle("Auto-flip", isOn: $autoFlip)
            HStack {
                Slider(value: $autoFlipDelay, in: 2...20, step: 1.0)
                Text(" (\(formattedDelay) (seconds)")
                    .font(.caption)
            }
            .disabled(!autoFlip)
            .padding(.bottom, 8)

            // This is a fudge. If I apply the label to the ScrollViewCarouselView
            // the label aligns with the bottom. So I apply the label to the
            // instructions and put the control after it without a label.
            LabeledContent("Card Background") {
                    Text("Scroll to select card background")
            }
            ScrollViewCarouselView(scrollID: $bgID)
                .padding(.bottom, 8)
        }
        .frame(width: 350)
        .padding()
        .onAppear {
            bgID = cardBackground.id
        }
        .onDisappear {
            cardBackground = CardBackgrounds.allCases.first(where: {$0.id == bgID })!
        }
    }
}

#Preview {
    MatchedPairsSettingsView()
}
