//
// -----------------------------------------
// Original project: Game2048
// Original package: Game2048
// Created on: 17/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//


import SwiftUI

struct LeaderBoardItemHeader: View {
    var body: some View {
        HStack {
            Text("Date")
                .font(.headline)
            Spacer()
            Text("Score")
                .font(.headline)
                .frame(width: 65, alignment: .trailing)
        }
        .foregroundStyle(.orange.opacity(0.85))
    }
}
