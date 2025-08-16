//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 16/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

public enum ToastType {
    case info, warning, error, success

    public var backgroundColor: Color {
        switch self {
        case .info:
            return Color.blue
        case .warning:
            return Color.yellow
        case .error:
            return Color.red
        case .success:
            return Color.green
        }
    }

    public var foregroundColor: Color {
        switch self {
        case .info:
            return Color.white
        case .warning:
            return Color.black
        case .error:
            return Color.white
        case .success:
            return Color.black
        }
    }

    public var iconName: String {
        switch self {
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}
