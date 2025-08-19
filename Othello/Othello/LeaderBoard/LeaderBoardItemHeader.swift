//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 04/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LeaderBoardItemHeader: View {
    var body: some View {
        HStack {
            Text("Date")
                .font(.headline)
                .frame(minWidth: 160, maxWidth: 160, alignment: .leading)
            Text("Player")
                .font(.headline)
            Spacer()
            Text("Score")
                .font(.headline)
        }.foregroundStyle(.orange.opacity(0.85))
    }
}
