//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 28/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GamePlayButtons: View {
    @State private var isPaused: Bool = false

    var onButtonPress: (KeyEquivalent) -> Void

    var body: some View {
        VStack(spacing: 6) {
            // Top row of buttons
            HStack(spacing: 6) {
                Spacer()
                makeButton(
                    caption: "arrowshape.up",
                    key: .upArrow
                )
                Spacer()
            }

            // Middle row of buttons
            HStack(spacing: 6) {
                makeButton(
                    caption: "arrowshape.backward",
                    key: .leftArrow
                )

                makeButton(
                    caption: isPaused
                    ? "play.circle"
                    : "pause.circle",
                    key: .space
                )

                makeButton(
                    caption: "arrowshape.forward",
                    key: .rightArrow
                )
            }

            // Bottom row of buttons
            HStack(spacing: 6) {
                Spacer()
                makeButton(
                    caption: "arrowshape.down",
                    key: .downArrow
                )
                Spacer()
            }
        }
        .frame(width: 250, height: 250)
    }

    func makeButton(caption: String, key: KeyEquivalent) -> some View {
        Button(action: {
            onButtonPress(key)
        }, label: {
            Image(systemName: caption)
                .resizable()
                .frame(width: 56, height: 56)
                .shadow(radius: 3, x: 2, y: 2)
        })
        .buttonStyle(.plain)
        .frame(width: 70, height: 70)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GamePlayButtons { key in
        print(key)
    }
}
