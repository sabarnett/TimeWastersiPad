//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 09/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class Word: Identifiable {
    let id = UUID()

    var word: String
    var found: Bool = false

    init(_ word: String) {
        self.word = word
    }
}
