//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct MatchedWordsView: View {
    var game: WordSearchViewModel
    var cellSize: CGFloat

    var body: some View {
        ZStack {
            ForEach(game.matchedWords) { matchedWord in
                Path { path in
                    path.move(to: startPoint(matchedWord))
                    path.addLine(to: endPoint(matchedWord))

                    path = path.strokedPath(
                        .init(
                            lineWidth: 1.0,
                            lineCap: .round,
                            lineJoin: .round,
                            miterLimit: 3.00
                        )
                    )
                }
                .stroke(Constants.selectedLineColor,
                        lineWidth: Constants.selectedLineWidth,
                        antialiased: true)
                .allowsHitTesting(false)
            }
        }
    }

    /// Calculate the center point of the cell at the start of the selected word.
    /// - Parameter matchedWord: The selected word coordinates
    /// - Returns: A CGPoint representing the middle of the first cell in
    /// the selected word.
    func startPoint(_ matchedWord: MatchedWord) -> CGPoint {
        CGPoint(
            x: transX(xPos: matchedWord.startX),
            y: transY(yPos: matchedWord.startY)
        )
    }

    /// Calculate the center point of the cell at the end of the selected word
    /// - Parameter matchedWord: The selected word coordinates
    /// - Returns: A CGPoint representing the middle of the last cell in
    /// the selected word.
    func endPoint(_ matchedWord: MatchedWord) -> CGPoint {
        CGPoint(
            x: transX(xPos: matchedWord.endX),
            y: transY(yPos: matchedWord.endY)
        )
    }

    /// Given the column number, calculate the center of the cell
    /// - Parameter x: The column to translate
    /// - Returns: The X position of the middle of the cell
    ///
    /// We add 2 to the X position to account for the spacing of the ZStack it is
    /// contained in.
    func transX(xPos: Int) -> CGFloat {
        (cellSize + 2) * CGFloat(xPos) + 2
        + (cellSize / 2)
    }

    /// Given the row number, calculate the center of the cell
    /// - Parameter y: The row number to translate
    /// - Returns: The X position of the middle of the cell
    ///
    func transY(yPos: Int) -> CGFloat {
        ((cellSize + 2) * CGFloat(yPos))
        + (cellSize / 2)
    }
}

#Preview {
    MatchedWordsView(game: WordSearchViewModel(),
                     cellSize: 30)
}
