//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 08/09/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct GamePlayButtons: View {
    @Binding var isPaused: Bool

    var onButtonPress: (KeyEquivalent) -> Void

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                // Top segment
                SegmentButton(
                    startAngle: .degrees(-135),
                    endAngle: .degrees(-45),
                    icon: "arrowtriangle.up.fill",
                    action: { onButtonPress(.upArrow) }
                )

                // Right segment
                SegmentButton(
                    startAngle: .degrees(-45),
                    endAngle: .degrees(45),
                    icon: "arrowtriangle.right.fill",
                    action: { onButtonPress(.rightArrow) }
                )

                // Bottom segment
                SegmentButton(
                    startAngle: .degrees(45),
                    endAngle: .degrees(135),
                    icon: "arrowtriangle.down.fill",
                    action: { onButtonPress(.downArrow) }
                )

                // Left segment
                SegmentButton(
                    startAngle: .degrees(135),
                    endAngle: .degrees(225),
                    icon: "arrowtriangle.left.fill",
                    action: { onButtonPress(.leftArrow) }
                )

                // Center Play button
                Button(action: {
                    onButtonPress(.space)
                }, label: {
                    Image(systemName: isPaused ? "play.fill" : "pause.circle")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(width: size * 0.3, height: size * 0.3)
                        .background(
                            Circle()
                                .fill(centerGradient)
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 4, y: 4)
                                .shadow(color: .white.opacity(0.7), radius: 6, x: -4, y: -4)
                        )
                })
                .buttonStyle(PressableButtonStyle())
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }

    // MARK: - Gradients
    private var centerGradient: RadialGradient {
        RadialGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.85), Color.blue.opacity(0.4)]),
            center: .center,
            startRadius: 5,
            endRadius: 80
        )
    }
}
