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

public class Translators {

    /// Takes the exit list in a room and returns a comma separated list of possible exits.
    ///
    /// - Parameter exits: The list of exits from the room
    /// - Returns: A comma separated list of exit directions
    public class func exitList(exits: [Int]) -> String {

        let exitList: [String] = [
            "north", "south", "east", "west", "up", "down"
        ]
        var availableExits: [String] = []

        for index in 0...5 where exits[index] != 0 {
            availableExits.append(exitList[index])
        }

        return availableExits.count == 0 ? "" : availableExits.joined(separator: ", ")
    }

    /// Returns a list of the items in a given location. The list is a comma
    /// separated list of items.
    ///
    /// - Parameters:
    ///   - items: All the items in the game
    ///   - location: The location you want the items from
    /// - Returns: A comma separated list of items or a blank string
    public class func itemsInALocation(items: [GameItem], location: Int) -> String {

        var itemList = ""

        let itemsInLocation = items.filter { $0.location == location }
        if itemsInLocation.count > 0 {
            let availableItems: [String] = itemsInLocation.map { $0.itemDescription }
            if availableItems.count > 0 {
                itemList = availableItems.joined(separator: ", ")
            }
        }

        return itemList
    }

    /// Returns a room description from a room object
    ///
    /// - Parameter room: The room to describe
    /// - Returns: The description of the room
    public class func roomDescription(room: GameRoom) -> String {

        if room.description.starts(with: "*") {
            return String(room.description.dropFirst())
        }

        return room.description
    }

    /// Takes a command line verb and translates short commands to full
    /// commands.
    ///
    /// - Parameter verb: The user entered verb
    /// - Returns: The translated verb or the original one if it isn't a short command
    public class func translateShortCommands(_ verb: String) -> String {

        switch verb.lowercased() {
        case "i":
            return "inventory"
        case "l":
            return "look"
        case "e":
            return "east"
        case "w":
            return "west"
        case "n":
            return "north"
        case "s":
            return "south"
        case "u":
            return "up"
        case "d":
            return "down"
        default:
            return verb
        }
    }
}
