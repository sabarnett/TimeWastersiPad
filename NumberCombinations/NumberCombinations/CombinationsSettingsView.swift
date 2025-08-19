//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct CombinationsSettingsView: View {

    @AppStorage(Constants.ncPlaySounds) private var playSounds = true
    @AppStorage(Constants.ncDisplayInterimResult) private var displayInterimResult: Bool = false

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $playSounds)
            Toggle("Show interim result", isOn: $displayInterimResult)
        }
    }
}

#Preview {
    CombinationsSettingsView()
}
