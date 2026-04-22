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

public struct WordCraftSettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage(Constants.wordcraftPlaySounds) private var wordcraftPlaySounds = true
    @AppStorage(Constants.wordcraftShowSelectedLetters) private var wordcraftShowSelectedLetters = true

    private var showClose = false

    public init(showClose: Bool = false) {
        self.showClose = showClose
    }

    public var body: some View {
        NavigationStack {
            Form {
                Toggle("Play sounds", isOn: $wordcraftPlaySounds)
                Toggle("Show selected letters", isOn: $wordcraftShowSelectedLetters)
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
    WordCraftSettingsView()
}
