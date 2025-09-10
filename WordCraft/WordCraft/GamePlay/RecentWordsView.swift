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
        Section(content: {
            ForEach(viewModel.usedWords.sorted(), id: \.self) { word in
                Text(word)
                    .fontWeight(.semibold)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
                    .frame(alignment: .leading)
            }
        }, header: {
            Text("Used Words").font(.title)
                .listSectionSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background {
                    Color.accentColor.opacity(0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
        })
        .listSectionSeparator(.hidden)
    }
}
