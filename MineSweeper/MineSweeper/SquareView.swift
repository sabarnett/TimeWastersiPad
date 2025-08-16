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

    var cellSize: CGFloat {
        switch gameDifficullty {
        case .beginner: return 60
        case .intermediate: return 50
        case .expert: return 35
        }
    }

    var textSize: CGFloat {
        switch gameDifficullty {
        case .beginner: return 30
        case .intermediate: return 24
        case .expert: return 18
        }
    }

    var color: Color {
        if square.isRevealed {
            .gray.opacity(0.2)
        } else {
            .gray
        }
    }

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
            }
        }
        .frame(width: cellSize, height: cellSize)
    }
}

#Preview {
    SquareView(square: Square(row: 0, column: 0))
}
