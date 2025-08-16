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

public struct ToastConfig: Equatable {
    /// Optional: A title for the message, shown larger and bolder then the message
    private(set) var title: String?

    /// The message to be displayed
    private(set) var message: String

    /// The systemName of the icon to display. If no icon name was provided in the config
    ///  a default will be generated based on the type of message.
    private(set) var iconName: String?

    /// The position of the toast message; top or bottom
    private(set) var alignment: ToastAlignment

    /// The type of toast message - determines the colour of the toast icon
    private(set) var type: ToastType

    /// Determines how many seconds the toast message is on screen before closing. Defaults to 3 seconds.
    private(set) var showDuration: Double = 3

    var icon: String {
        iconName ?? type.iconName
    }

    public init(
        title: String? = nil,
        message: String,
        icon: String? = nil,
        alignment: ToastAlignment = .top,
        type: ToastType = .info,
        showDuration: Double = 3
    ) {
        self.title = title
        self.message = message
        self.iconName = icon
        self.alignment = alignment
        self.type = type
        self.showDuration = showDuration
    }
}
