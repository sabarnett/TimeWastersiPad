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

@main
struct TimeWastersApp: App {
    @AppStorage(Constants.displayMode) var displayMode: DisplayMode = .system

    @State private var showLaunch = true

    var body: some Scene {
        WindowGroup {
            if showLaunch {
                LaunchScreen()
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showLaunch = false
                            }
                        }
                    }
            } else {
                ContentView()
                    .preferredColorScheme(displayMode.colorScheme)
            }
        }
    }
}
