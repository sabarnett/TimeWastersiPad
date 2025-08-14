//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 14/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct Constants {
    // About box
    static let homeUrl: URL = URL(string: "http://www.sabarnett.co.uk")!
    static let homeAddress: String = "sabarnett.co.uk"

    // Application level settings keys
    static let displayMode = "colorMode"
}

extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var copyright: String {getInfo("NSHumanReadableCopyright")
        .replacing("\\\\n", with: "\n") }

    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }

    fileprivate func getInfo(_ str: String) -> String {
        infoDictionary?[str] as? String ?? "⚠️"
    }

    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
