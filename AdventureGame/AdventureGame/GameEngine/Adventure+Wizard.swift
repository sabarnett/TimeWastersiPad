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
