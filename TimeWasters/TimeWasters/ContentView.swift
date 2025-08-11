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
import SharedComponents

struct ContentView: View {
    var body: some View {
        VStack {
            List {
                ForEach(Game.allCases, id: \.self) { game in
                    
                    Text(game.gameDefinition.title)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
