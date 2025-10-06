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
    var game: Game

    var body: some View {
        GameViewFactory().gameView(for: game)
    }
}

#Preview {
    GameView(game: Game.wordcraft)
}
