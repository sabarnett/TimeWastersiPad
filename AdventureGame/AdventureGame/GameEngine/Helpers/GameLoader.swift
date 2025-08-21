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

public class GameLoader {

    /// Reference to the closure we use to post status messages back.
    private var feedbackMessage: ((_: String) -> Void)?

    /// Checks whether we have a feedback closeure and, if we do, sends a\
    /// message to it.
    ///
    /// - Parameter message: The message to send back.
    private func sendFeedback(_ message: String) {
        if let fbMessage = feedbackMessage {
            fbMessage(message)
        }
    }

    /// Helper method to send feedback if the debugging option has been set.
    ///
    /// - Parameters:
    ///   - isDebug: Indicates whether debugging is active
    ///   - message: The message to send if debugging is active
    private func debugPrint(_ isDebug: Bool, _ message: String) {
        if isDebug {
            sendFeedback(message)
        }
    }

    /// Loads the text of the game definition into the game objects
    ///
    /// - Parameters:
    ///   - game: The game object to be loaded.
    ///   - fromDataFile: The text loaded from the game file
    ///   - feedback: A closure used to send feedback
    public func load(
        game: Adventure,
        fromDataFile: String,
        feedback: @escaping (String) -> Void
    ) {

        // provide an optional feedback mechanism
        feedbackMessage = feedback

        // Initialise the counters to 0 and set the flags to false
        game.counters = Counters()
        game.flags = BitFlags()
        game.savedRooms = [Int](repeating: 0, count: game.SAVEDROOMCOUNT)

        let gameData = GameDataReader(dataSet: fromDataFile) as GameDataReaderProtocol
        loadGameHeader(toGame: game, fromDataFile: gameData)

        // Load as many actions as the file says are there
        loadActions(toGame: game, fromDataFile: gameData)

        // Load verbs and nouns
        loadNounsAndVerbs(toGame: game, fromDataFile: gameData)

        // Load rooms
        loadRooms(toGame: game, fromDataFile: gameData)

        // Load messages
        loadMessages(toGame: game, fromDataFile: gameData)

        // Load items
        loadItems(toGame: game, fromDataFile: gameData)

        // Add comments to actions
        loadActionComments(toGame: game, fromDataFile: gameData)

        // Load version info
        game.gameHeader.gameVersion = (try? gameData.readInt()) ?? 0
        game.gameHeader.dameId = (try? gameData.readInt()) ?? 0
        game.gameHeader.gameTrailer = (try? gameData.readInt()) ?? 0
    }

    /// Load the game header. We expect a standard header consisting of
    /// 12 header fields. We delegate this function to the object itself.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadGameHeader(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        game.gameHeader.load(fromDataFile: dataFile)
    }

    /// Load the available actions.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadActions(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        for _ in 0...game.gameHeader.numberOfActions {

            let action = GameAction(forGame: game, fromDataFile: dataFile)
            game.actions.append(action)
        }
    }

    /// Loads the list of nouns and verbs that the game recognises. These
    /// are stored as simple array's as they're just simple lists of words.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadNounsAndVerbs(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        for _ in 0...game.gameHeader.numberOfWords {
            game.verbs.append(dataFile.nextLine())
            game.nouns.append(dataFile.nextLine())
        }
    }

    /// Loads the rooms that players can go into and the exists that
    /// will take them to other exciting and dangerous destinations... it says here.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadRooms(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        for _ in 0...game.gameHeader.numberOfRooms {

            let room = GameRoom(fromDataFile: dataFile)
            game.rooms.append(room)
        }
    }

    /// Loads the messages. These are simple lists of strings that may be issued to
    /// the game player, so no need for a specialised class.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadMessages(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {

        for _ in 0...game.gameHeader.numberOfMessages {

            let line = dataFile.nextLine()
            game.messages.append(line)
        }
    }

    /// Load the items that game players can collect and their initial locations
    /// in the game.
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadItems(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {

        for _ in 0...game.gameHeader.numberOfItems {
            let item = GameItem(fromDataFile: dataFile)
            game.items.append(item)
        }
    }

    /// Loads the comments into the already loaded actions objects
    ///
    /// - Parameters:
    ///   - game: a reference to the game object
    ///   - dataFile: The internal data file containing the lines from
    /// the game data read from disk.
    private func loadActionComments(toGame game: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {

        for lineNo in 0...game.gameHeader.numberOfActions {
            let line = dataFile.nextLine()
            game.actions[lineNo].comment = line
        }
    }
}
