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

struct GameItemButtonView: View {
    @Environment(\.colorScheme) private var colorScheme

    var game: GameDefinition
    var infoPressed: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: game.gameIcon)
                    Text(game.title)
                        .bold()
                }
            }
            Spacer()
            Image(systemName: "info.square")
                .onTapGesture {
                    infoPressed()
                }
        }
        .padding(8)
        .foregroundStyle(.white)
    }
}

#Preview {
    GameItemButtonView(game: GameDefinition.example, infoPressed: { })
}
