//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 14/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct WordCraftToolBar: View {

    @State var viewModel: WordCraftViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Show game rules")

            Spacer()

            Text(viewModel.score.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)
            Spacer()

            Button(action: {
                viewModel.showResetConfirmation = true
            }, label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Restart the game")

            Button(action: {
                viewModel.saveGame()
            }, label: {
                Image(systemName: "tray.and.arrow.down.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Save the current game state.")

            Button(action: {
                viewModel.showReloadConfirmation = true
            }, label: {
                Image(systemName: "tray.and.arrow.up.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Reload the last saved game.")

            Button(action: {
                viewModel.toggleSounds()
            }, label: {
                Image(systemName: viewModel.speakerIcon)
                    .padding(5)
            })
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    WordCraftToolBar(viewModel: WordCraftViewModel())
}
