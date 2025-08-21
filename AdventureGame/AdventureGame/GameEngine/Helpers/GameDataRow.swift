//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 28/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

class GameDataRow: Identifiable {
    init(message: String, type: GameRowDataType) {
        text = message
        dataType = type
    }

    public var id: UUID = UUID()
    public var text: String = ""
    public var dataType: GameRowDataType = .consoleOutput
}
