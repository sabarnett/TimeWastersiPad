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

struct ScorePanel: View {
    @Bindable var model: GameModel

    var performMove: ((MoveDirection) -> Void)

    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            // Title
            VStack(alignment: .center, spacing: 4) {
                Text(String(model.gameLevel.target))
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.47, green: 0.43, blue: 0.40))
                
                Text("Join the tiles, get to \(model.gameLevel.target)!")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.60, green: 0.56, blue: 0.52))
                    .lineSpacing(4)
            }
            
            // Scores
            VStack(spacing: 12) {
                ScoreCardView(title: "SCORE", score: model.score)
                ScoreCardView(title: "BEST", score: model.bestScore)
            }
            
            Spacer()
            
            // Controls
            VStack(spacing: 16) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        model.newGame()
                    }
                } label: {
                    Label("New Game", systemImage: "arrow.counterclockwise")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(red: 0.95, green: 0.58, blue: 0.39))
                        )
                }
                .sensoryFeedback(.impact, trigger: model.score == 0)
                
                // Arrow key pad
                DirectionalPadView { direction in
                    performMove(direction)
                }
            }
            
            Spacer()
            
            // Instructions hint
            VStack(alignment: .leading, spacing: 6) {
                Label("Swipe or use arrow pad", systemImage: "hand.draw")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.66, blue: 0.62))
                Label("Merge matching tiles", systemImage: "square.on.square")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.66, blue: 0.62))
            }
        }
    }
}
