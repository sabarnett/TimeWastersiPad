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

struct SegmentButton: View {
    @Environment(\.colorScheme) private var colorScheme

    let startAngle: Angle
    let endAngle: Angle
    let icon: String
    let action: () -> Void

    var body: some View {
        GeometryReader { geometry in
            let rect = geometry.frame(in: .local)
            let shape = SegmentShape(startAngle: startAngle, endAngle: endAngle)

            Button(action: action) {
                ZStack {
                    // Segment Background
                    shape
                        .fill(segmentGradient)
                        .overlay(
                            shape.stroke(colorScheme == .dark
                                         ? Color.white.opacity(0.3)
                                         : Color.black.opacity(0.3)
                                         , lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.25), radius: 5, x: 4, y: 4)
                        .shadow(color: .white.opacity(0.6), radius: 5, x: -4, y: -4)

                    // Icon
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(.white)
                        .position(positionForIcon(in: rect))
                }
            }
            .contentShape(shape)
            .buttonStyle(PressableButtonStyle())
        }
    }

    private var segmentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.35), Color.gray.opacity(0.15)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func positionForIcon(in rect: CGRect) -> CGPoint {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 * 0.7
        let midAngle = (startAngle.radians + endAngle.radians) / 2

        return CGPoint(
            x: center.x + CGFloat(cos(midAngle)) * radius,
            y: center.y + CGFloat(sin(midAngle)) * radius
        )
    }
}
