//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

public struct GameDefinition: Identifiable, CustomStringConvertible, Hashable {
    public var id: Game
    public var title: String
    public var tagLine: String
    public var description: String = ""
    public var gamePlay: String = ""
    public var credits: String = ""
    public var link: String = ""
    public var settingsIcon: String? = nil
    
    public static var example: GameDefinition {
        GameDefinition(id: Game.minesweeper, title: "Game Title", tagLine: "Tag line",
            description: "Description", gamePlay: "Game play",
             credits: "Credits line", link: "Link")
    }
}
