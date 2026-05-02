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

        // If wizard mode is enabled and this is a wizard command
        // and we can excute it, then we're done here.
        if executeWizardMode(verb: verb, noun: noun) { return }

        verb = Translators.translateShortCommands(verb)

        // There are commands to print the current noun. Who knows why!
        self.noun = noun

        let (vIndex, nIndex) = getVerbAndNounIndex(verb: verb, noun: noun)

        // If we have been unable to work out the command, tell them so.
        // if vIndex == 0 || nIndex == 0 {
        if vIndex == 0 {
            display(message: "You use cryptic words I do not understand!")
            return
        }

        var recognisedCommand = ""
        switch runMatchingActions(vIndex: vIndex, nIndex: nIndex) {
        case .actSuccess:
            return
        case .actFailedConditions:
            recognisedCommand = "I can't do that yet."
        default:
            recognisedCommand = "I don't understand your command."
        }

        if autoGoTo(withVerb: vIndex, toLocationIndex: nIndex) { return }
        if autoGet(withVerb: vIndex, itemWithIndex: nIndex) { return }
        if autoDrop(withVerb: vIndex, itemWithIndex: nIndex) { return }

        // Nothing left, we just don't recognise the command or can't do it yet.
        display(message: recognisedCommand)
    }

    /// Get the index of the verb and noun, allowing for thepossibility we only have one so
    /// have to infer the other (e.g. "n" infers to "go n"
    ///
    /// - Parameters:
    ///   - verb: The verb the user entered
    ///   - noun: The noun the user entered
    ///
    /// - Returns: A tuple containing the verb and noun index
    private func getVerbAndNounIndex(verb: String, noun: String) ->
    (vIndex: Int, nIndex: Int) {
        let wordLength = gameHeader.wordLength

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

        return (vIndex, nIndex)
    }

    private func executeWizardMode(verb: String, noun: String) -> Bool {
        if options.wizardMode
            && verb.count > 0
            && wizardCommand(verb: verb, noun: noun) {
            return true
        }

        return false
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
