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

    // Function to evaluate formulas using different parenthetical structures
    func evaluateFormula(_ operators: [String],
                         _ values: [Double],
                         _ pattern: Int
    ) -> Double? {
        var result: Double?

        let op1 = operators[0]
        let op2 = operators[1]
        let op3 = operators[2]

        let p1 = values[0]
        let p2 = values[1]
        let p3 = values[2]
        let p4 = values[3]

        switch pattern {
        case 1:
            if let r1 = applyOperator(p1, p2, op1),
               let r2 = applyOperator(r1, p3, op2),
               let r3 = applyOperator(r2, p4, op3) {
                result = r3
            }
        case 2:
            if let r1 = applyOperator(p2, p3, op2),
               let r2 = applyOperator(p1, r1, op1),
               let r3 = applyOperator(r2, p4, op3) {
                result = r3
            }
        case 3:
            if let r1 = applyOperator(p2, p3, op2),
               let r2 = applyOperator(r1, p4, op3),
               let r3 = applyOperator(p1, r2, op1) {
                result = r3
            }
        case 4:
            if let r1 = applyOperator(p3, p4, op3),
               let r2 = applyOperator(p2, r1, op2),
               let r3 = applyOperator(p1, r2, op1) {
                result = r3
            }
        case 5:
            if let r1 = applyOperator(p1, p2, op1),
               let r2 = applyOperator(p3, p4, op3),
               let r3 = applyOperator(r1, r2, op2) {
                result = r3
            }
        default:
            break
        }

        // Ensure final result is an integer
        return (result != nil && result!.truncatingRemainder(dividingBy: 1) == 0) ? result : nil
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
