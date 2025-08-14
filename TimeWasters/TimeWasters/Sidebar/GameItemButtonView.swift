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
                Text(game.title).font(.title3).bold()
                Text(game.description).font(.caption).lineLimit(2)
            }
            Spacer()
            Image(systemName: "info.square")
                .font(.title3)
                .onTapGesture {
                    infoPressed()
                }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.accentColor.opacity(colorScheme == .dark ? 0.4 : 0.3))
                .shadow(color: .secondary, radius: 3, x: 3, y: 3)
        }
    }
}

#Preview {
    GameItemButtonView(game: GameDefinition.example, infoPressed: { })
}
