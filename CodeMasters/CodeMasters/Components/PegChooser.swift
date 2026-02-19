//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 14/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct PegChooser: View {
    let pegChoices: [Peg]
    var onTapped: (Peg) -> Void

    var body: some View {
        HStack {
            ForEach(pegChoices.indices, id: \.self) { idx in
                PegView(peg: pegChoices[idx])
                    .onTapGesture {
                        onTapped(pegChoices[idx])
                    }
            }
        }
    }
}

#Preview {
    PegChooser(pegChoices: ["red", "blue", "green"], onTapped: { _ in })
}
