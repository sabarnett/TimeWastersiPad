//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 17/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct CodeView<AncillaryView>: View where AncillaryView: View {
    let code: Code
    @Binding var selection: Int
    @ViewBuilder let ancillaryView: () -> AncillaryView

    init(code: Code,
        selection: Binding<Int> = .constant(0),
        @ViewBuilder ancillaryView: @escaping () -> AncillaryView = { EmptyView() }) {
        self.code = code
        self._selection = selection
        self.ancillaryView = ancillaryView
    }

    var body: some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { idx in
                PegView(peg: code.kind == .master(reveal: false) ? "gray" : code.pegs[idx])
                    .shadow(color: .secondary, radius: (idx == selection && code.kind == .guess) ? 10 : 0)
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = idx
                        }
                    }
            }

            // Final rectangle for the match markers
            Color.clear.aspectRatio(1, contentMode: .fit)
                .overlay {
                    ancillaryView()
                }
        }
    }
}

#Preview {
    CodeView(code: Code(kind: .guess, pegCount: 5))
}
