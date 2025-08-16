//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 18/09/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GameBoardView: View {

    @AppStorage(Constants.wordcraftShowSelectedLetters) private var wordcraftShowSelectedLetters = true

    @State var viewModel: WordCraftViewModel

    var body: some View {
        VStack {
            HStack(spacing: 2) {
                ForEach(0..<viewModel.columns.count, id: \.self) { col in
                    VStack(spacing: 2) {
                        let column = viewModel.columns[col]

                        ForEach(column) { tile in
                            Button {
                                viewModel.select(tile)
                            } label: {
                                Text(tile.letter)
                                    .font(.largeTitle.weight(.bold))
                                    .fontDesign(.rounded)
                                    .frame(width: 120, height: 50)
                                    .foregroundStyle(viewModel.foreground(for: tile))
                                    .background(viewModel.background(for: tile).gradient)
                            }
                            .buttonStyle(.borderless)
                            .transition(.push(from: .top))
                        }
                    }
                }
            }
            if wordcraftShowSelectedLetters {
                HStack {
                    ForEach(viewModel.selectedLetters, id: \.self) { tile in
                        Text(tile.letter)
                            .font(.title.weight(.bold))
                            .fontDesign(.rounded)
                            .frame(width: 30, height: 25)
                            .foregroundStyle(.black)
                            .background(.green.gradient)
                    }
                }
                .frame(minHeight: 40)
            }
        }
    }
}
