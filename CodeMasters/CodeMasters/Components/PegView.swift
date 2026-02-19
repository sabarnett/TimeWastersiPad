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

struct PegView: View {
    @Namespace var pegNameSpace

    let peg: Peg

    var body: some View {
        if let colour = Color.init(name: peg) {
            // We have colours for pegs
            RoundedRectangle(cornerRadius: 10)
                .overlay {
                    if peg == Peg.missing {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(colour)
        } else {
            RoundedRectangle(cornerRadius: 10)
                .overlay {
                    if peg == Peg.missing {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray)
                    }
                }
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(Color(uiColor: UIColor.systemBackground))

                .overlay {
                    // We have emojis
                    Text(peg)
                        .font(.system(size: 120))
                        .minimumScaleFactor(9/120) // Font between 9 and 120
                        .contentShape(RoundedRectangle(cornerRadius: 10))
                        .aspectRatio(1, contentMode: .fit)
                }
        }
    }
}

#Preview {
    PegView(peg: Peg.missing)
}
