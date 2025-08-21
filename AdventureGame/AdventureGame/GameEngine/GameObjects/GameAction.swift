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

public class GameAction {

    public var verb: Int = 0
    public var noun: Int = 0
    public var conditions: [ActionCondition] = [ActionCondition]()
    public var instructions: [ActionInstruction] = [ActionInstruction]()
    public var args: [Int] = [Int]()
    public var comment: String = ""
    private let game: Adventure

    init(forGame: Adventure, fromDataFile dataFile: GameDataReaderProtocol) {
        game = forGame

        let verbNoun = (try? dataFile.readInt()) ?? 0
        var conds: [ActionCondition] = [ActionCondition]()
        var args: [Int] = [Int]()

        for _ in 0...4 {
            let condValue = (try? dataFile.readInt()) ?? 0

            let condition = condValue % 20
            let conditionValue = condValue / 20

            if condition == 0 {
                args.append(conditionValue)
            } else {
                let actionCondition = ActionCondition(
                    forGame: forGame,
                    withCondition: condition,
                    usingValue: conditionValue
                )
                conds.append(actionCondition)
            }
        }

        var instructions = [ActionInstruction]()

        for _ in 0...1 {
            let instr = (try? dataFile.readInt()) ?? 0

            let id1: Int = instr / 150
            let id2: Int = instr % 150

            if (id1) != 0 {
                instructions.append(ActionInstruction(forGame: forGame, withId: id1))
            }

            if (id2) != 0 {
                instructions.append(ActionInstruction(forGame: forGame, withId: id2))
            }
        }

        verb = verbNoun / 150
        noun = verbNoun % 150
        conditions = conds
        self.instructions = instructions
        self.args = args
    }
}

extension GameAction: CustomStringConvertible {

    // CustomStringConvcertible protocol implementation
    public var description: String {
        return "Verb: \(verb), Noun: \(noun)\r\n"
            + "   Conditions: \(conditions)"
            + "   Instructions: \(instructions)"
            + "   Args: \(args)"
    }
}

extension GameAction {

    public func execute(testChance: Bool) -> ActionExecutionResults {

        if !allConditionsAreTrue() {
            return .actFailedConditions
        }

        if testChance && verb == 0 && noun < 100 {
            // It's an occurrance and may be random ? whatever that means!
            let dice = arc4random_uniform(100)
            if dice >= noun {
                return .actSuccess
            }
        }

        // Clone an array??? Need a copy for the instruction execute
        var argCopy = args.map { $0 }

        var seenContinue = false
        for instruct in instructions {
            let result = instruct.execute(&argCopy)
            seenContinue = seenContinue || result
        }

        return seenContinue ? .actContinue : .actSuccess
    }

    private func allConditionsAreTrue() -> Bool {
        for cond in conditions {
            if !cond.evaluate() {
                return false
            }
        }

        return true
    }
}

public enum ActionExecutionResults {
    case actFailedConditions
    case actSuccess
    case actContinue
    case actNoMatch
}
