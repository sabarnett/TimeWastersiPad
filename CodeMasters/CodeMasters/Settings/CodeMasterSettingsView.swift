//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 13/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

public struct CodeMasterSettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage(Constants.cmPlaySounds) private var cmPlaySounds = true
    @AppStorage(Constants.cmGameLevel) private var cmGameLevel: CodeMasterGameLevel = .easy
    @AppStorage(Constants.cmGameTheme) private var cmGameTheme: String = Themes.Random

    var showClose = false

    public init(showClose: Bool = false) {
        self.showClose = showClose
    }

    public var body: some View {
        NavigationStack {
            Form {
                Toggle("Play sounds", isOn: $cmPlaySounds)
                
                Picker("Game level", selection: $cmGameLevel) {
                    ForEach(CodeMasterGameLevel.allCases) { level in
                        Text(level.description)
                            .tag(level)
                    }
                }
                
                Picker("Theme", selection: $cmGameTheme) {
                    Text(Themes.Random).tag(Themes.Random)
                    
                    let themes = Themes()
                    ForEach(themes.themeNames(), id:\.self) { theme in
                        Text(theme).tag(theme)
                    }
                }
            }
            .toolbar {
                if showClose {
                    ToolbarItem {
                        if #available(iOS 26.0, *) {
                            Button(role: .close,
                                   action: { dismiss() }
                            )
                            .glassEffect()
                        } else {
                            Button(role: .cancel,
                                   action: { dismiss() },
                                   label: { Image(systemName: "xmark.app").scaleEffect(1.3) }
                            )
                        }
                    }
                }
            }

        }
    }
}

#Preview {
    CodeMasterSettingsView()
}
