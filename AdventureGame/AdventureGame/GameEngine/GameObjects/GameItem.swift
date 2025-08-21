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

public class GameItem {

    var itemDescription: String = ""
    var itemName: String = ""
    var location: Int = 0
    var startLocation: Int = 0

    /// Load a game item
    ///
    /// - Parameter dataFile: The data file to read lines of data from.
    ///
    /// Items are a bit if a pig. At their simplest, they will consist of a
    /// string followed by a location (number). The string, hwever, may also
    /// contain a sub-string. For example:
    ///
    ///         "Ring of skeleton keys/KEY/" 2
    ///
    /// First complexity is that the number on the end of the line may actually
    /// be on the next line. It's rare but it does happen.
    ///
    /// Just to make it more complicated, the "/" may actually be "//" in some
    /// malformed files.
    ///
    /// We need to decode all of this in to the game item.
    init(fromDataFile dataFile: GameDataReaderProtocol) {

        var line = dataFile.nextLine()

        /// If the room number is on the next line, load it now.
        if dataFile.nextLineIsNumeric() {
            let nextValue = (try? dataFile.readInt()) ?? 0
            line += "\" \(String(nextValue))"
        }

        // Handle the invalid files I found where the "/" was coded as "//"
        line = line.replacingOccurrences(of: "//", with: "/")
        let itemParts = line.split(separator: "\"")

        if itemParts.count > 1 {
            location = Int(itemParts[1].trimmingCharacters(in: [" "]))!
            startLocation = location
        }

        if itemParts[0].contains("/") {
            let descParts = itemParts[0].split(separator: "/")
            itemDescription = String(descParts[0])
            itemName = String(descParts[1])
        } else {
            itemDescription = String(itemParts[0])
        }
    }
}

extension GameItem: CustomStringConvertible {
    public var description: String {
        return "Item: \(itemDescription) Name: \(itemName) In Location: \(location)"
    }
}
