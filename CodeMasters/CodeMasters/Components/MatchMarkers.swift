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

enum Match {
    case nomatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match]

    var body: some View {
        HStack {
            ForEach(matches.indices, id: \.self) { index in
                if index.isMultiple(of: 2) {
                    VStack {
                        matchMarker(peg: index)
                        matchMarker(peg: index + 1)
                    }
                }
            }
        }
    }

    @ViewBuilder
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact }
        let foundCount = matches.count { $0 != .nomatch }

        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear,
                          lineWidth : 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Preview and preview helpers

#Preview {
    VStack {
        // 3
        MMPreview(colors: [.red, .blue, .green],
                  matches: [.exact, .inexact, .exact])

        // 4
        MMPreview(colors: [.red, .blue, .green, .yellow],
                  matches: [.nomatch, .exact, .inexact, .exact])
        MMPreview(colors: [.green, .yellow, .red, .blue],
                  matches: [.nomatch, .exact, .inexact, .exact])

        // 5
        MMPreview(colors: [.red, .orange, .blue, .yellow, .pink],
                  matches: [.inexact, .inexact, .exact, .inexact, .exact])

        // 6
        MMPreview(colors: [.yellow, .orange, .pink, .red, .blue, .green],
                  matches: [.nomatch, .exact, .inexact, .exact, .inexact, .exact])
    }
}

struct MMPreview: View {
    var colors: [Color]
    var matches: [Match]
    var body: some View {
        HStack {
            ForEach(colors.indices, id: \.self) { idx in
                Circle()
                    .foregroundStyle(colors[idx])
            }

            MatchMarkers(matches: matches)
        }
        .padding(.horizontal)
    }
}
