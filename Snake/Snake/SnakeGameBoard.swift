//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 10/09/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct SnakeGameBoard: View {
    @State var game: SnakeGame

    var cellSize: CGFloat = 50
    var pause: Bool = true
    var headAngle: CGFloat {
        switch game.direction {
        case .up:
            270
        case .down:
            90
        case .left:
            180
        case .right:
            0
        }
    }

    var body: some View {
        ZStack {
            ForEach(game.snake, id: \.self) { segment in

                if game.isSnakeHead(segment) {
                    game.snakeHead()
                        .resizable()
                        .frame(width: cellSize, height: cellSize)
                        .rotationEffect(Angle(degrees: headAngle))
                        .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                                  y: CGFloat(segment.y) * cellSize + cellSize / 2)
                } else {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: cellSize, height: cellSize)
                        .position(x: CGFloat(segment.x) * cellSize + cellSize / 2,
                                  y: CGFloat(segment.y) * cellSize + cellSize / 2)
                }
            }

            Image(systemName: "applelogo")
                .scaleEffect(2.2)
                .foregroundStyle(.red)
                .frame(width: cellSize, height: cellSize)
                .position(x: CGFloat(game.food.x) * cellSize + cellSize / 2,
                          y: CGFloat(game.food.y) * cellSize + cellSize / 2)

            if pause {
                Image(systemName: "pause.circle.fill")
                    .scaleEffect(4)
                    .zIndex(1)
                    .foregroundStyle(.white)
            }
        }

    }
}

#Preview {
    SnakeGameBoard(game: SnakeGame(), cellSize: 40)
}
