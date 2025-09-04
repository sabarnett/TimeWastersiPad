//
//  SquareView.swift
//  Minesweeper
//
//  Created by Paul Hudson on 03/08/2024.
//

import SwiftUI

struct SquareView: View {

    @AppStorage(Constants.mineGameDifficulty) private var gameDifficullty: GameDifficulty = .beginner

    var square: Square
    var cellSize: CGFloat
    var textSize: CGFloat { cellSize * 0.6 }
    var color: Color { square.isRevealed ? .gray.opacity(0.2) : .gray }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(color.gradient)

            if square.isRevealed {
                if square.hasMine {
                    Text("💥")
                        .font(.system(size: textSize * 1.3))
                        .shadow(color: .red, radius: 1)
                } else if square.nearbyMines > 0 {
                    Text(String(square.nearbyMines))
                        .font(.system(size: textSize))
                }
            } else if square.isFlagged {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(.black, .yellow)
                    .shadow(color: .black, radius: 3)
                    .font(.system(size: textSize))
            }
        }
        .frame(width: cellSize, height: cellSize)
    }
}

#Preview {
    SquareView(square: Square(row: 0, column: 0), cellSize: 30.0)
}
