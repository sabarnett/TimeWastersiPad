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

struct WordCraftRuleView: View {

    @State var viewModel: WordCraftViewModel

    var body: some View {
        HStack {
            Button(action: {
                viewModel.changeRule()
            }, label: {
                Image(systemName: "arrow.uturn.left.circle")
            })
            .buttonStyle(PlainButtonStyle())
            .help("Change the wordcraft rule")

            Text(viewModel.currentRule.name)
                .contentTransition(.numericText())
        }.font(.system(size: 22))
    }
}
