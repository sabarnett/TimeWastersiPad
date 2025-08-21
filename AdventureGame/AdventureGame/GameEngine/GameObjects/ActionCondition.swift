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

public class ActionCondition {

    public enum Condition: Int {
        case param = 0                  // Param = none
        case carried = 1                // Param = item
        case here = 2                   // Param = item
        case present = 3                // Param = item
        case at = 4                     // Param = room
        case notHere = 5                // Param = item
        case notCarried = 6             // Param = item
        case notAt = 7                  // Param = room
        case flag = 8                   // Param = number
        case notFlag = 9                // Param = number
        case loaded  = 10
        case notLoaded = 11
        case notPresent = 12            // Param = item
        case exists = 13                // Param = item
        case notExists = 14             // Param = item
        case counterLe = 15            // Param = number
        case counterGt = 16            // Param = nmumber
        case notMoved = 17              // Param = item
        case moved = 18                 // Param = item
        case counterEq = 19            // Param = number
    }

    public var condition: Condition = .param
    public var value: Int = 0
    private let game: Adventure

    init(forGame: Adventure, withCondition: Condition, usingValue: Int) {
        game = forGame
        condition = withCondition
        value = usingValue
    }
}

extension ActionCondition {
    convenience init(forGame: Adventure, withCondition: Int, usingValue: Int) {
        guard let cond = Condition(rawValue: withCondition) else {
            fatalError("Error loading file - condition encountered with invalid value: \(withCondition)")
        }

        self.init(forGame: forGame, withCondition: cond, usingValue: usingValue)
    }

    convenience init(forGame: Adventure, withCondition: String, usingValue: String) {

        guard let cond = Int(withCondition) else {
            fatalError("Invalid condition - condition with value \(withCondition) is not supported.")
        }

        guard let val = Int(usingValue) else {
            fatalError("Invalid condition - The conditioin with value \(withCondition) has an invalid value: \(usingValue)")
        }

        self.init(forGame: forGame, withCondition: cond, usingValue: val)
    }
}

extension ActionCondition: CustomStringConvertible {
    public var description: String {
        return "Condition: \(condition) With Value: \(value)"
    }
}

extension ActionCondition {

    public func evaluate() -> Bool {
        var item: GameItem?

        let location = game.location

        if value < game.items.count {
            item = game.items[value]
        }

        switch condition {
        case .param:
            fatalError("unexpected condition code 0")
        case .carried:
            return item!.location == game.ROOMCARRIED
        case .here:
            return item!.location == location
        case .present:
            return item!.location == game.ROOMCARRIED || item!.location == location
        case .at:
            return location == value
        case .notHere:
            return item!.location != location
        case .notCarried:
            return item!.location != game.ROOMCARRIED
        case .notAt:
            return location != value
        case .flag:
            return game.flags[value]
        case .notFlag:
            return !game.flags[value]
        case .loaded:
            return game.carriedCount() != 0
        case .notLoaded:
            return game.carriedCount() == 0
        case .notPresent:
            return item!.location != game.ROOMCARRIED && item!.location != location
        case .exists:
            return item!.location != game.ROOMNOWHERE
        case .notExists:
            return item!.location == game.ROOMNOWHERE
        case .counterLe:
            return game.counter <= value
        case .counterGt:
            return game.counter > value
        case .notMoved:
            return item!.location == item!.startLocation
        case .moved:
            return item!.location != item!.startLocation
        case .counterEq:
            return game.counter == value
        }
    }
}
