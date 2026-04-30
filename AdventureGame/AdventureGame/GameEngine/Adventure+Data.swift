//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 30/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import Foundation

public class Adventure {

    /// Called when the game engine wants to display a message to the user
    public var displayText: ((_: String) -> Void)?

    /// Called when the game engive wants input
    public var displayPrompt: ((_: String) -> Void)?

    /// Returns a list of items that are currently being carried
    public var carriedItems: [String] {
        let items = items.filter { $0.location == ROOMCARRIED }.map {$0.itemDescription}
        return items.count > 0 ? items : ["Nothing is being carried"]
    }
    public var carriedItemsCount: Int {
        let items = items.filter { $0.location == ROOMCARRIED }.map {$0.itemDescription}
        return items.count
    }

    /// Returns a lisat of the treasures that have been found and left in the treasure room
    public var treasures: [String] {
        let treasures = items.filter {
            $0.itemDescription.hasPrefix("*") && $0.location == gameHeader.treasureRoom
        }

        if treasures.count > 0 {
            return treasures.map { $0.itemDescription
                    .replacingOccurrences(of: "*", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return ["You have no treasures"]
    }

    /// Returns the percentage of treasures that have been collected.
    public var treasuresFound: Int {
        let treasureCount = items.filter {
            $0.itemDescription.hasPrefix("*") && $0.location == gameHeader.treasureRoom
        }.count
        return 100 * (treasureCount) / gameHeader.treasures
    }

    let VERBGO = 1         // Fixed verb for go
    let VERBGET = 10       // Fixed verb for get
    let VERBDROP = 18      // Fixed verb for drop
    let ITEMLAMP = 9       // Lamp is always item 9
    let ROOMCARRIED = -1   // Fixed value
    let ROOMOLDCARRIED = 255  // Fixed value
    let ROOMNOWHERE = 0    // Fixed value
    let SAVEDROOMCOUNT = 32     // Number of saved rooms matches the number of flags

    var gameHeader: GameHeader = GameHeader()
    var flags: BitFlags = BitFlags()
    var options: GameOptions
    var rooms = [GameRoom]()
    var items = [GameItem]()
    var actions = [GameAction]()
    var nouns = [String]()
    var verbs = [String]()
    var messages = [String]()
    var counters = Counters()
    var savedRooms = [Int]()
    var location: Int = 0
    var counter: Int = 0
    var lampLeft: Int = 0
    var savedRoom: Int = 0
    var noun: String = ""

    var needToLook: Bool = true
    var finished: Bool = false

    var goDirections = ["XXX", "n", "s", "e", "w", "u", "d"]

    public init(withOptions: GameOptions) {
        options = withOptions
    }

    /// Loads a game file into the gane object, decoding the various objects
    /// into their component parts.
    ///
    /// - Parameter fromData: The data file that we want to load. This is expected
    /// to be a string with the contents of the file, as read from disk.
    public func loadGame(fromData: String) {
        let loader = GameLoader()
        loader.load(game: self, fromDataFile: fromData) { (message) in
            print(message)
        }
    }

    /// Sends a message to the UI if the method has been hooked into
    ///
    /// - Parameter message: The message to send
    public func display(message: String) {
        if let textDisplay = displayText {
            textDisplay(message)
        }
    }

    /// Sends a request into the UI to input data. Is used to indicate that
    /// the last request has completed.
    ///
    /// - Parameter message: The prompt to the user.
    public func promptUser(_ message: String = "Tell me what to do") {
        if let promptDisplay = displayPrompt {
            promptDisplay(message)
        }
    }
}
