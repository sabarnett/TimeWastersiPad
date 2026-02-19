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

import Foundation

struct Theme {
    let name: String
    let items: [String]
}

struct Themes {

    static let Random = "Random"
    
    var themes: [Theme] = [
        Theme(name: "Bright Colours",
              items: ["red", "blue", "green", "yellow", "orange", "purple"]),
        Theme(name: "Earth Tones",
              items: ["green", "brown", "black", "orange", "yellow"]),
        Theme(name: "Smiley Faces",
              items: ["😀", "😎", "😂", "🤣", "😇", "😍", "🤨"]),
        Theme(name: "Balls",
              items: ["⚽️", "⚾️", "🎱", "🏈", "🏓"]),
        Theme(name: "Sports",
              items: ["🏋🏻‍♀️", "🏌🏻", "🏄🏻", "🚴🏻", "🏊🏽‍♂️", "🤾🏻‍♂️"])
    ]

    var randomTheme: Theme {
        guard let theme = themes.randomElement() else {
            return themes.first!
        }
        return theme
    }

    func theme(named name: String) -> Theme? {
        guard let theme = themes.first(where: { $0.name == name }) else { return nil }
        return theme
    }

    func themeNames() -> [String] {
        themes.map { $0.name }
    }
}
