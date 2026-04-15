//
// -----------------------------------------
// Original project: 2048
// Original package: 2048
// Created on: 13/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ScoreCardView: View {
    let title: String
    let score: Int

    @State private var displayScore: Int = 0
    @State private var bump: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(Color(red: 0.80, green: 0.76, blue: 0.72))
                .tracking(1.5)

            Text("\(displayScore)")
                .font(.system(size: 26, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .contentTransition(.numericText(value: Double(displayScore)))
                .scaleEffect(bump ? 1.15 : 1.0)
        }
        .frame(minWidth: 120)
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.47, green: 0.43, blue: 0.40))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .onChange(of: score) { _, newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                displayScore = newValue
                bump = true
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.15)) {
                bump = false
            }
        }
        .onAppear { displayScore = score }
    }
}
