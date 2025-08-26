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

/// Code to actually run the game
extension Adventure {

    /// Set the game initial parameters and display the opening credits. If we have a
    /// saved game, then we reload it now.
    public func initiliseGame() {
        finished = false
        location = gameHeader.playerRoom
        lampLeft = gameHeader.lightTime

        let gameId = "AdventureKit, a Scott Adams game toolkit in Swift"
        let copyright = "(c) Scott Adams & 2024 Steven Barnett"

        display(message: "\(gameId)\n\(copyright)")
    }

    /// Displays the prompt to the user to enter a command. Before we do that
    /// we may have to display the current location, the exits and the items that
    /// are here.
    public func promptForTurn() {
        _ = runMatchingActions(vIndex: 0, nIndex: 0)
        if needToLook {
            actuallyLook()
        }

        promptUser()
    }

    /// Displays the current location, the exits and any items that are here.
    public func actuallyLook() {
        needToLook = false

        if flags.darkFlag {
            display(message: "I can't see... it's too dark.\nMoving around in the dark can be dangerous.")
        }

        let room = rooms[location]
        display(message: Translators.roomDescription(room: room))

        let xits = Translators.exitList(exits: room.exits)
        display(message: "Obvious exits are \(xits)")

        let itms = Translators.itemsInALocation(items: items, location: location)
        if !items.isEmpty {
            display(message: "I can also see: \(itms)")
        }
    }

    /// Takes the command the user hs entered and executes it.
    ///
    /// - Parameter command: The command entered by the user. Should be
    /// one or two words separated by a space.
    public func processTurn(command: String) {

        if finished {
            display(message: "The game is over - restart it to play again.")
            return
        }

        let words = command.split(separator: " ")
        if words.count == 0 {
            display(message: "I do not understand.")
            return
        }

        if words.count == 1 {
            executeCommand(withVerb: String(words[0]), andNoun: "")
        } else {
            executeCommand(withVerb: String(words[0]), andNoun: String(words[1]))
        }

        processLighting()
        promptUser()
    }

    /// Execute a command. We will have a command which has been split into
    /// two words, the first being the command (verb) and the second being an
    /// optional parameter (noun) to operate on. We need to translate these
    /// into the commands identified in the game file.
    ///
    /// - Parameters:
    ///   - verb: The command to execute
    ///   - noun: An optional parameter to the command
    public func executeCommand(withVerb: String, andNoun: String) {

        var verb = withVerb
        let noun = andNoun
        let wordLength = gameHeader.wordLength

        if options.wizardMode && verb.count > 0 {
            if wizardCommand(verb: verb, noun: noun) {
                return
            }
        }

        verb = Translators.translateShortCommands(verb)

        // There are commands to print the current noun. Who knows why!
        self.noun = noun

        var vIndex = ListManager.find(word: verb, inList: verbs, wordLength: wordLength)
        var nIndex = ListManager.find(word: noun, inList: nouns, wordLength: wordLength)

        if vIndex == 0 && noun == "" {
            var tmp = ListManager.find(word: verb, inList: nouns, wordLength: wordLength)
            if tmp == 0 {
                tmp = ListManager.find(word: verb, inList: goDirections, wordLength: wordLength)
            }

            if tmp != 0 {
                vIndex = VERBGO
                nIndex = tmp
            }
        }

        // If we have been unable to work out the command, tell them so.
        // if vIndex == 0 || nIndex == 0 {
        if vIndex == 0 {
            display(message: "You use cryptic words I do not understand!")
            return
        }

        var recognisedCommand = false
        switch runMatchingActions(vIndex: vIndex, nIndex: nIndex) {
        case .actSuccess:
            return
        case .actFailedConditions:
            recognisedCommand = true
        default:
            recognisedCommand = false
        }

        if autoGoTo(withVerb: vIndex, toLocationIndex: nIndex) { return }
        if autoGet(withVerb: vIndex, itemWithIndex: nIndex) { return }
        if autoDrop(withVerb: vIndex, itemWithIndex: nIndex) { return }

        // Nothing left, we just don't recognise the command or can't do it yet.
        if recognisedCommand {
            display(message: "I can't do that yet.")
        } else {
            display(message: "I don't understand your command.")
        }
    }

    public func carriedCount() -> Int {
        return items.filter {
            $0.location == ROOMCARRIED
        }.count
    }

    public func processLighting() {

        // No lamp left!
        if lampLeft <= 0 { return }

        // Is the lamp in a valid location?
        if items.count >= ITEMLAMP || items[ITEMLAMP].location == ROOMNOWHERE { return }

        lampLeft -= 1

        if lampLeft == 0 {
            display(message: "Your lamp has run out.")
            flags.lampDead = true
            if isDark() {
                needToLook = true
                actuallyLook()
            }
        } else if lampLeft < 25 && lampLeft % 5 == 0 {
            display(message: "Your light is growing dim.")
        }
    }

    /// Based on the verb and noun values, run the action assoicated with this location.
    ///
    /// - Parameters:
    ///   - vIndex: Verb Index
    ///   - nIndex: Noun Index
    ///
    /// - Returns: Indictor of whether this action worked.
    public func runMatchingActions(vIndex: Int, nIndex: Int) -> ActionExecutionResults {
        var recognisedCommand = false

        // Shorten the actions list to the ones that match the selected verb. It will
        // make the search easier.
        let filteredActions = actions.filter { (action) -> Bool in
            action.verb == vIndex
        }
        for actionIndex in 0..<filteredActions.count {

            let action = filteredActions[actionIndex]
            let isMatch = vIndex == action.verb && (vIndex == 0 || (nIndex == action.noun || action.noun == 0))

            if isMatch {
                recognisedCommand = true

                let result = action.execute(testChance: vIndex == 0)
                switch result {

                case .actSuccess:
                    if vIndex != 0 {
                        return .actSuccess
                    }
                case .actContinue:
                    var index = actionIndex
                    while true {
                        index += 1
                        let action = actions[index]
                        if action.verb != 0 || action.noun != 0 {
                            break
                        }

                        _ = action.execute(testChance: false)
                    }
                    if vIndex != 0 {
                        return .actSuccess
                    }

                default:
                    // When it fails, we do nothing
                    break
                }
            }
        }

        let returnCode: ActionExecutionResults = recognisedCommand ? .actFailedConditions : .actNoMatch
        return returnCode
    }

    /// Displays a list of the items the player is carrying
    public func inventory() {
        let carryMessage: String = "I am carrying:"

        let carriedItems = items.filter { $0.location == ROOMCARRIED }.map {$0.itemDescription}

        if carriedItems.count == 0 {
            display(message: "\(carryMessage)\nNothing")
        } else {
            display(message: "\(carryMessage)\n\(carriedItems.joined(separator: "\n"))")
        }
    }

    /// Displays the current score and ends the game if the player has all
    /// of the treasures.
    public func score() {
        let count = items.filter {
            $0.itemDescription.hasPrefix("*") && $0.location == gameHeader.treasureRoom
        }.count

        display(message: "You have gathered \(count) treasures.")

        let percentage = 100 * count / gameHeader.treasures
        display(message: "On a scale of 0 to 100, that rates \(percentage)")

        if count == gameHeader.treasures {
            display(message: "Well done, you have everything!")
            finish(1)
        }
    }

    public func isDark() -> Bool {
        if items.count <= ITEMLAMP {
            return flags.darkFlag
        }

        let loc = items[ITEMLAMP].location
        return flags.darkFlag && loc != ROOMCARRIED && loc != location
    }

    public func finish(_ retcode: Int) {
        finished = true
        display(message: "Game Over")
    }
}

extension Adventure {

    public func autoGoTo(withVerb vIndex: Int, toLocationIndex nIndex: Int) -> Bool {

        if vIndex != VERBGO { return false }
        if nIndex < 1 || nIndex > 6 { return false }

        if isDark() {
            display(message: "It's dangerous to move in the dark...")
        }

        let newLocation = rooms[location].exits[nIndex - 1]
        if newLocation != 0 {
            location = newLocation
            needToLook = true
            actuallyLook()
        } else if isDark() {
            display(message: "I fell down and broke my neck.")
            finish(2)
        } else {
            display(message: "I can't go in that direction.")
        }

        return true
    }

    public func autoGet(withVerb: Int, itemWithIndex index: Int) -> Bool {
        if withVerb != VERBGET { return false }

        if index == 0 {
            display(message: "What?")
            return true
        }

        let noun = nouns[index].uppercased()

        let item = items.filter {
            $0.itemName.uppercased() == noun && $0.location == location
        }

        if item.count != 1 {
            display(message: "It is beyond my power to do that.")
        } else if carriedCount() == gameHeader.maximumCarryItems {
            display(message: "I already have too much to carry.")
        } else {
            item[0].location = ROOMCARRIED
            display(message: "Ok")
        }

        return true
    }

    public func autoDrop(withVerb: Int, itemWithIndex index: Int) -> Bool {
        if withVerb != VERBDROP { return false }

        if index == 0 {
            display(message: "What?")
            return true
        }

        let noun = nouns[index].uppercased()
        let item = items.filter {
            $0.itemName.uppercased() == noun && $0.location == ROOMCARRIED
        }

        if item.count != 1 {
            display(message: "It is beyond my power to do that.")
            return true
        }

        item[0].location = location
        display(message: "Ok")
        return true
    }
}

extension Adventure {

    /// Wizard Commands are commands that effectively let you cheat. They have to
    /// be enabled in the game options to be available.
    ///
    /// - Parameters:
    ///   - verb: The command verb
    ///   - noun: The command noun (options)
    ///
    /// - Returns: True if the command executes, else false
    public func wizardCommand(verb: String, noun: String) -> Bool {

        let verbUpper = verb.uppercased()

        switch verbUpper {

        case "#SG":
            wizardSuperGet(itemAtIndex: noun)

        case "#GO":
            wizardTeleport(toRoomAtIndex: noun)

        case "#WHERE":
            wizardFind(item: noun)

        case "#SET":
            wizardSet(option: noun)

        case "#CLEAR":
            wizardClear(option: noun)

        default:
            // Unknown wizard command, so cannot process it
            return false
        }

        return true
    }

    public func wizardSuperGet(itemAtIndex: String) {

        guard let index = Int(itemAtIndex) else { return }
        if index < 0 || index > items.count {
            display(message: "\(index) is out of range. There are only \(items.count) items.")
            return
        }

        items[index].location = ROOMCARRIED
        display(message: "SuperGot: \(items[index].itemDescription)")
    }

    public func wizardTeleport(toRoomAtIndex: String) {
        guard let index = Int(toRoomAtIndex) else { return }
        if index < 0 || index > rooms.count {
            display(message: "\(index) is out of range. There are only \(rooms.count) rooms.")
            return
        }

        location = index
        needToLook = true
    }

    public func wizardFind(item: String) {

        guard let index = Int(item) else { return }
        if index < 0 || index > items.count {
            display(message: "\(index) is out of range. There are only \(items.count) items.")
            return
        }

        let item = items[index]
        let message = "Item \(index): '\(item.itemDescription)' at room \(item.location) '\(rooms[item.location].description)'"
        display(message: message)
    }

    public func wizardSet(option: String) {

        switch option.lowercased() {
        case "c":
            options.showConditions = true
        case "i":
            options.showInstructions = true
        case "p":
            options.showParse = true
        default:
            display(message: "Option '\(option)' is an unrecognised option.")
        }
    }

    public func wizardClear(option: String) {

        switch option.lowercased() {
        case "c":
            options.showConditions = false
        case "i":
            options.showInstructions = false
        case "p":
            options.showParse = false
        default:
            display(message: "Option '\(option)' is an unrecognised option.")
        }
    }
}
