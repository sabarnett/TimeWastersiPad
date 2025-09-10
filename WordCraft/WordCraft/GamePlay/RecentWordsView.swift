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
    @Environment(\.colorScheme) private var colorScheme

    @State var viewModel: WordCraftViewModel

    var body: some View {

        ZStack {
            if colorScheme == .dark {
                Color.gray.opacity(0.3).ignoresSafeArea()
            } else {
                Color.gray.opacity(0.2).ignoresSafeArea()
            }

            VStack(alignment: .leading) {
                Text("Used Words")
                    .font(.title)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background {
                        Color.accentColor.opacity(0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                ScrollView {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(viewModel.usedWords.sorted(), id: \.self) { word in
                            Text(word)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
