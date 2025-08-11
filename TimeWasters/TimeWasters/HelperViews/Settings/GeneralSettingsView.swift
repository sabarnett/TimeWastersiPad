//
// -----------------------------------------
// Original project: TimeWasters
// Original package: TimeWasters
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(Constants.darkMode) private var isDarkMode = false

    var body: some View {
        Form {
            Toggle(isOn: $isDarkMode, label: {
                Text("Dark mode")
            })
        }
    }
}

#Preview {
    GeneralSettingsView()
}
