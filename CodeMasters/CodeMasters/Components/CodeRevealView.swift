//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 19/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct CodeRevealView: View {
    @Environment(\.dismiss) private var dismiss

    let pegs: [Peg]
    let attempts: Int

    var body: some View {
        VStack {
            Text("Code Reveal").font(.title).padding()

            Text("After ^[\(attempts) attempt](inflect: true), you have failed to find the code. You were looking for:")
                .font(.title2)
            Spacer()
            PegChooser(pegChoices: pegs) { _ in }
            Spacer()

            Button("Play again") { dismiss() }
                .buttonStyle(.borderedProminent)
                .padding()
        }.padding()
    }
}

#Preview {
    CodeRevealView(pegs: ["red", "blue", "green"], attempts: 5)
}
