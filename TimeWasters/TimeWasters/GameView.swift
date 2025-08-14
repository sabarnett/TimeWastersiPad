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

import SharedComponents
import SwiftUI

struct GameView: View {
    @Binding var game: Game?

    var body: some View {
        if let game {
            GameViewFactory().gameView(for: game)
        } else {
            Text("No game selected")
        }
    }
}

#Preview {
    GameView(game: .constant(nil))
}
