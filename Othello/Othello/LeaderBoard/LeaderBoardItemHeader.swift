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
            Spacer()
            Text("Player")
                .font(.headline)
                .frame(width: 65, alignment: .center)
            Text("Score")
                .font(.headline)
                .frame(width: 65, alignment: .trailing)
        }
        .foregroundStyle(.orange.opacity(0.85))
    }
}
