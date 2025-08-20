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
            Spacer()

            Text(viewModel.score.formatted(.number.precision(.integerLength(3))))
                .fixedSize()
                .padding(.horizontal, 6)
                .foregroundStyle(.red.gradient)

            Spacer()
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    WordCraftToolBar(viewModel: WordCraftViewModel())
}
