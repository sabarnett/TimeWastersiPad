//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

public struct GameOptions {

    public init() {
    }

    public var wizardMode: Bool = false
    public var restoreFile: Bool = false
    public var readFile: Bool = false
    public var echoInput: Bool = false
    public var bugTolerant: Bool = true
    public var noWait: Bool = false
    public var showTokens: Bool = false
    public var showRandom: Bool = false
    public var showParse: Bool = false
    public var showConditions: Bool = false
    public var showInstructions: Bool = false
    public var showMessages: Bool = true
    public var showRooms: Bool = true
    public var showActions: Bool = true
    public var showItems: Bool = true
}
