//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
// Created on: 15/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

enum SnakeGameSize: Int, Identifiable, CaseIterable, CustomStringConvertible {
    case small = 14
    case medium = 20
    case large = 30

    var id: Int { rawValue }

    var description: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}
