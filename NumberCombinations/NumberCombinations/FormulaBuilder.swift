//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

struct FormulaBuilder {

    // Function to safely perform floating-point division while ensuring an integer result
    func safeDivide(_ x: Double, _ y: Double) -> Double? {
        let result = x / y
        return result.truncatingRemainder(dividingBy: 1) == 0 ? result : nil
    }

    // Function to apply an operator and return a valid result
    func applyOperator(_ x: Double, _ y: Double, _ op: String) -> Double? {
        switch op {
        case "+":
            return x + y
        case "-":
            return x - y
        case "*":
            return x * y
        case "/":
            return safeDivide(x, y)
        default:
            return nil
        }
    }

    private struct Operation {
        let leftIndex: Int   // negative = result index (e.g. -1 = r1, -2 = r2)
        let rightIndex: Int
        let opIndex: Int
    }

    // Each pattern represents a different parenthesisation of the expression
    // p1 op1 p2 op2 p3 op3 p4, e.g:
    //   pattern 1: ((p1 op1 p2) op2 p3) op3 p4  — left to right
    //   pattern 5: (p1 op1 p2) op2 (p3 op3 p4)  — split pairs
    //
    // Rather than a switch with one branch per pattern, each pattern is encoded
    // as a sequence of three Operations. An Operation specifies which two operands
    // to combine and which operator to apply. Operands are identified by index:
    //   - Non-negative index (0-3): refers to the original values array
    //   - Negative index (-1, -2): refers to a previous intermediate result,
    //     where -1 is the result of step 1, -2 is the result of step 2, etc.
    //
    // resolve(_:) translates these indices into concrete Double values at runtime,
    // looking up either the original value or the already-computed result.
    // Steps are executed in order, each appending its result to the results array,
    // with the final element being the answer.
    func evaluateFormula(_ operators: [String],
                         _ values: [Double],
                         _ pattern: Int
    ) -> Double? {
        let patterns: [[Operation]] = [
            // case 1: ((p1 op1 p2) op2 p3) op3 p4
            [Operation(leftIndex: 0, rightIndex: 1, opIndex: 0),
             Operation(leftIndex: -1, rightIndex: 2, opIndex: 1),
             Operation(leftIndex: -2, rightIndex: 3, opIndex: 2)],

            // case 2: (p1 op1 (p2 op2 p3)) op3 p4
            [Operation(leftIndex: 1, rightIndex: 2, opIndex: 1),
             Operation(leftIndex: 0, rightIndex: -1, opIndex: 0),
             Operation(leftIndex: -2, rightIndex: 3, opIndex: 2)],

            // case 3: p1 op1 ((p2 op2 p3) op3 p4)
            [Operation(leftIndex: 1, rightIndex: 2, opIndex: 1),
             Operation(leftIndex: -1, rightIndex: 3, opIndex: 2),
             Operation(leftIndex: 0, rightIndex: -2, opIndex: 0)],

            // case 4: p1 op1 (p2 op2 (p3 op3 p4))
            [Operation(leftIndex: 2, rightIndex: 3, opIndex: 2),
             Operation(leftIndex: 1, rightIndex: -1, opIndex: 1),
             Operation(leftIndex: 0, rightIndex: -2, opIndex: 0)],

            // case 5: (p1 op1 p2) op2 (p3 op3 p4)
            [Operation(leftIndex: 0, rightIndex: 1, opIndex: 0),
             Operation(leftIndex: 2, rightIndex: 3, opIndex: 2),
             Operation(leftIndex: -1, rightIndex: -2, opIndex: 1)]
        ]

        guard pattern >= 1, pattern <= patterns.count else { return nil }

        let steps = patterns[pattern - 1]
        var results: [Double] = []

        func resolve(_ index: Int) -> Double? {
            if index >= 0 { return values[index] }
            let ri = -index - 1          // -1 → 0, -2 → 1
            return ri < results.count ? results[ri] : nil
        }

        for step in steps {
            guard let left  = resolve(step.leftIndex),
                  let right = resolve(step.rightIndex),
                  let result = applyOperator(left, right, operators[step.opIndex])
            else { return nil }
            results.append(result)
        }

        guard let final = results.last,
              final.truncatingRemainder(dividingBy: 1) == 0
        else { return nil }

        return final
    }

    // Function to generate a random floating-point formula that results in an integer
    func generateRandomFormula(values: [FormulaValue]) -> (String, Int)? {
        let numbers = [Double(values[0].value),
                       Double(values[1].value),
                       Double(values[2].value),
                       Double(values[3].value)]
        let operators = ["+", "-", "*", "/"]
        let patterns = [1, 2, 3, 4, 5]

        // Shuffle numbers randomly
        let shuffledNumbers = numbers.shuffled()

        for _ in 0..<1000 { // Try multiple attempts
            let op1 = operators.randomElement()!
            let op2 = operators.randomElement()!
            let op3 = operators.randomElement()!
            let pattern = patterns.randomElement()!

            let p1 = shuffledNumbers[0]
            let p2 = shuffledNumbers[1]
            let p3 = shuffledNumbers[2]
            let p4 = shuffledNumbers[3]

            if let result = evaluateFormula([op1, op2, op3], [p1, p2, p3, p4], pattern) {
                let formulaString: String
                switch pattern {
                case 1:
                    formulaString = "((\(p1) \(op1) \(p2)) \(op2) \(p3)) \(op3) \(p4)"
                case 2:
                    formulaString = "(\(p1) \(op1) (\(p2) \(op2) \(p3))) \(op3) \(p4)"
                case 3:
                    formulaString = "\(p1) \(op1) ((\(p2) \(op2) \(p3)) \(op3) \(p4))"
                case 4:
                    formulaString = "\(p1) \(op1) (\(p2) \(op2) (\(p3) \(op3) \(p4)))"
                case 5:
                    formulaString = "(\(p1) \(op1) \(p2)) \(op2) (\(p3) \(op3) \(p4))"
                default:
                    continue
                }
                return (formulaString, Int(result))
            }
        }

        return nil
    }
}
