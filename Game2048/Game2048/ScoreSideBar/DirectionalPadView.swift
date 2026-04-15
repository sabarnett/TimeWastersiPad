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

struct DirectionalPadView: View {
    let onMove: (MoveDirection) -> Void

    var body: some View {
        VStack(spacing: 6) {
            arrowButton(direction: .up, systemImage: "chevron.up")
            HStack(spacing: 6) {
                arrowButton(direction: .left, systemImage: "chevron.left")
                arrowButton(direction: .down, systemImage: "chevron.down")
                arrowButton(direction: .right, systemImage: "chevron.right")
            }
        }
    }

    private func arrowButton(direction: MoveDirection, systemImage: String) -> some View {
        Button {
            onMove(direction)
        } label: {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color(red: 0.47, green: 0.43, blue: 0.40))
                .frame(width: 56, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.72, green: 0.67, blue: 0.63).opacity(0.4))
                )
        }
        .sensoryFeedback(.selection, trigger: UUID())
    }
}
