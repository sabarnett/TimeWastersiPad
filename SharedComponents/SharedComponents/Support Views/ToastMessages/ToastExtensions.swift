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

public extension View {
    func toast(toastMessage: Binding<ToastConfig?>) -> some View {
        ZStack {
            self
            Toast(toastMessage: toastMessage)
        }
    }
}
