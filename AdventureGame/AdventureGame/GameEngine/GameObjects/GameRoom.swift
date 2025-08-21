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

public class GameRoom {

    var roomDescription: String = ""
    var exits: [Int] = [Int]()

    init(fromDataFile dataFile: GameDataReaderProtocol) {

        exits = [Int]()

        // There are 6 possible exits
        for _ in 0...5 {
            let exit = (try? dataFile.readInt()) ?? 0
            exits.append(exit)
        }

        roomDescription = dataFile.nextLine()
    }
}

extension GameRoom: CustomStringConvertible {
    public var description: String {
        return "Room \(roomDescription) - Exits \(exits)"
    }
}
