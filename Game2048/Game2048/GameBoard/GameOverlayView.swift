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

struct GameOverlayView: View {
    let gameState: GameState
    let onRestart: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)

            VStack(spacing: 24) {
                Text(gameState == .won ? "🎉" : "😔")
                    .font(.system(size: 72))

                Text(gameState == .won ? "You Win!" : "Game Over")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(gameState == .won
                        ? Color(red: 0.93, green: 0.73, blue: 0.18)
                        : Color(red: 0.47, green: 0.43, blue: 0.40))

                Button {
                    onRestart()
                } label: {
                    Text("Play Again")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(red: 0.95, green: 0.58, blue: 0.39))
                                .shadow(color: Color(red: 0.95, green: 0.58, blue: 0.39).opacity(0.4),
                                        radius: 10, x: 0, y: 5)
                        )
                }
                .sensoryFeedback(.impact(flexibility: .solid), trigger: true)
            }
        }
        .transition(.asymmetric(
            insertion: .scale(scale: 0.8).combined(with: .opacity),
            removal: .opacity
        ))
    }
}
