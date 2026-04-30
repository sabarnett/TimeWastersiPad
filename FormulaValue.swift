//
// -----------------------------------------
// Original project: 
// Original package: 
// Created on: 30/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct FormulaValue {

    var value: Int
    var isUsed: Bool = false

    init(_ value: Int) {
        self.value = value
    }

    var color: Color {
        isUsed ? .gray : .blue
    }
}
