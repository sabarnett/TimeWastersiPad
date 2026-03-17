//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 17/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct WanderingDigitsSettingsView: View {

    @AppStorage(Constants.wdPlaySounds) private var wdPlaySounds = true

    public init() { }

    public var body: some View {
        Form {
            Toggle("Play sounds", isOn: $wdPlaySounds)
        }
    }
}

#Preview {
    WanderingDigitsSettingsView()
}
