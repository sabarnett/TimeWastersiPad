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

struct RecentWordsView: View {
    @State var viewModel: WordCraftViewModel

    var body: some View {
        List(selection: $viewModel.submittedWord) {
            ForEach(viewModel.usedWords.sorted(), id: \.self) { word in
                Text(word)
                    .fontWeight(.semibold)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .padding(0)
            }
        }
        .listStyle(.plain)
        .listSectionSeparator(.hidden)
        .environment(\.defaultMinListRowHeight, 0) // HERE
        .frame(width: 240)
    }
}
