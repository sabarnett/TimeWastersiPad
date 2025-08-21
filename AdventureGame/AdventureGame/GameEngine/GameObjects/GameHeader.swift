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

public class GameHeader {
    // First 12 settings in the file. Many of these settings drove the
    // the loading of the game.
    //
    // Note: There is an unknown value at the start of the file and at the
    // end of the file - no idea what these are, but I store them anyway in case
    // I eventually find out.
    public var unknown: Int = 0
    public var numberOfItems: Int = 0
    public var numberOfActions: Int = 0
    public var numberOfWords: Int = 0
    public var numberOfRooms: Int = 0
    public var maximumCarryItems: Int = 0
    public var playerRoom: Int = 0
    public var treasures: Int = 0
    public var wordLength: Int = 0
    public var lightTime: Int = 0
    public var numberOfMessages: Int = 0
    public var treasureRoom: Int = 0

    // These are read from the trailer of the file, not the header.
    public var gameVersion: Int = 0
    public var dameId: Int = 0
    public var gameTrailer: Int = 0

    public func load(fromDataFile dataFile: GameDataReaderProtocol) {

        self.unknown = (try? dataFile.readInt()) ?? 0
        self.numberOfItems = (try? dataFile.readInt()) ?? 0
        self.numberOfActions = (try? dataFile.readInt()) ?? 0
        self.numberOfWords = (try? dataFile.readInt()) ?? 0
        self.numberOfRooms = (try? dataFile.readInt()) ?? 0
        self.maximumCarryItems = (try? dataFile.readInt()) ?? 0
        self.playerRoom = (try? dataFile.readInt()) ?? 0
        self.treasures = (try? dataFile.readInt()) ?? 0
        self.wordLength = (try? dataFile.readInt()) ?? 0
        self.lightTime = (try? dataFile.readInt()) ?? 0
        self.numberOfMessages = (try? dataFile.readInt()) ?? 0
        self.treasureRoom = (try? dataFile.readInt()) ?? 0

    }
}
