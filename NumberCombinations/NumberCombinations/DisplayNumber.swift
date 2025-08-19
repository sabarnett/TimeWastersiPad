//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI

struct DisplayNumber: View {
    var value: FormulaValue
    var isResult: Bool = false

    init(_ value: FormulaValue, asResult: Bool = false) {
        self.value = value
        isResult = asResult
    }

    var cellWidth: CGFloat { isResult ? 120 : 90 }
    var cellHeight: CGFloat { isResult ? 70 : 90 }
    var cellColor: Color { isResult ? .green : value.color }

    var body: some View {
        Text("\(value.value)")
            .font(.system(size: 48, weight: .bold))
            .frame(width: cellWidth, height: cellHeight)
            .background(cellColor.opacity(0.6).gradient)
            .border(Color.black, width: 1)
    }
}
