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

    private enum AddBrackets: CaseIterable {
        case firstTwo
        case middleTwo
        case lastTwo
        case firstThree
        case lastThree
        case none
    }

    public func generateRandomFormula(values: [FormulaValue]) -> (String, Int)? {
        var result: Int?
        var formula: String = ""
        var retryCount: Int = 150

        while retryCount > 0 {
            let operators = getOperators()
            var formulaParts: [String] = buildFormulaPartsArray(values: values, operators: operators)
            formulaParts = addFormulaBrackets(formulaParts: formulaParts)
            formula = formulaParts.joined()

            let eval = FormulaEvaluator()
            do {
                result = try eval.evaluate(expression: formula)
                return(formula, result!)
            } catch {
                // We didn't get a vlid result, so the formula must be invalid (probably
                // resulted ina divide by zero result) so we try again.
                result = nil
            }

            retryCount -= 1
        }

        // If we run out of retries, just give up
        return nil
    }

    // Return three operators to use in the formula. If we get more than
    // one divide, we replace all but one of them with another operator.
    private func getOperators() -> [String] {
        let validOperators: [String] = ["+", "-", "*", "/"]
        let nonDivOperators: [String] = ["+", "-", "*"]

        var operators = [
            validOperators.randomElement(),
            validOperators.randomElement(),
            validOperators.randomElement()
        ]

        // We want to limit divisions to a single division - it gets too
        // complicated if we allow more than one division.
        while operators.count(where: { $0 == "/"}) > 1 {
            let div = operators.firstIndex(where: {$0 == "/"})!
            operators[div] = nonDivOperators.randomElement()!
        }

        return operators.compactMap { $0 }
    }

    private func buildFormulaPartsArray(values: [FormulaValue], operators: [String]) -> [String] {
        var formulaParts: [String] = []

        formulaParts.append(String(values[0].value))
        formulaParts.append(operators[0])
        formulaParts.append(String(values[1].value))
        formulaParts.append(operators[1])
        formulaParts.append(String(values[2].value))
        formulaParts.append(operators[2])
        formulaParts.append(String(values[3].value))

        return formulaParts
    }

    private func addFormulaBrackets(formulaParts: [String]) -> [String] {
        let brackets = AddBrackets.allCases.randomElement()!
        var parts = formulaParts

        switch brackets {
        case .firstTwo:
            parts.insert("(", at: 0)
            parts.insert(")", at: 4)
        case .middleTwo:
            parts.insert("(", at: 2)
            parts.insert(")", at: 6)
        case .lastTwo:
            parts.insert("(", at: 4)
            parts.append(")")
        case .firstThree:
            parts.insert("(", at: 0)
            parts.insert(")", at: 6)
        case .lastThree:
            parts.insert("(", at: 2)
            parts.append(")")
        case .none:
            break
        }

        return parts
    }

    private func testFormulaEvaluation(formula: String) -> Int? {
        let expression = NSExpression(format: formula)
        return expression.expressionValue(with: nil, context: nil) as? Int
    }
}
