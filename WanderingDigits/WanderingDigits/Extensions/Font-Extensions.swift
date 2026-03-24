//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 18/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

extension Font {
    /// Game play font for the numbers.
    static var numberFont: Font {
        Font.system(size: 50)
            .monospacedDigit()
    }

    /// Font to use in the 'show solution' popup
    static var numberFontSmall: Font {
        Font.system(size: 30)
            .monospacedDigit()
    }

    /// Font to use to show the math operator
    static var operatorFont: Font {
        Font.system(size: 70)
            .monospacedDigit()
    }
}
