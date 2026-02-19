//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 14/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

extension Color {
    private static let nameToColor: [String: Color] = [
        "black": .black,
        "white": .white,
        "gray": .gray,
        "grey": .gray,
        "red": .red,
        "green": .green,
        "blue": .blue,
        "orange": .orange,
        "yellow": .yellow,
        "pink": .pink,
        "purple": .purple,
        "primary": .primary,
        "secondary": .secondary,
        "accent": .accentColor,
        "accentcolor": .accentColor,
        "brown": .brown,
        "cyan": .cyan,
        "indigo": .indigo,
        "mint": .mint,
        "teal": .teal,
        "clear": .clear
    ]

    init?(name: String) {
        let normalizedName = name.lowercased().replacingOccurrences(of: " ", with: "")
        guard let color = Self.nameToColor[normalizedName] else {
            return nil
        }
        self = color
    }
}

