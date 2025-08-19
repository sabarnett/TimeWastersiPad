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

enum EvaluationErrors: Error {
    case invalidCharacter(char: Character)
    case unknownOperator(oper: Character)
    case divideByZero
    case unexpectedToken
    case incompleteFormula
}

struct FormulaEvaluator {

    typealias ResultType = Int

    private enum Token: Equatable {
        case number(ResultType)
        case operatorSymbol(Character)
        case leftParenthesis
        case rightParenthesis
    }

    /// Evaluate an expression and return the result of that expression.
    ///
    /// - Parameter expression: The expression as a plain text string
    /// - Returns: Te result of calculating the expression
    ///
    /// - Throws:
    ///     InvalidCharacter - when an invalidf character is found
    ///     unknownOperator - when an operator is found that is not one of our valid operators
    ///     divideByZero - if the expression includes a divide by operation and the divisor is zero
    ///     unexpectedToken - if the formula is malformed
    ///     incompleteFormula - if the formula is incomplete. e.g. 3+
    ///
    public func evaluate(expression: String) throws -> ResultType {
        /*
         How this works...
        
         Suppose we start with a formula consisting of "(1 + 2 * 3) / 4". The call to
         tokenize will return an arry of the tokenized parts of the formula:
        
         [0] = leftParenthesis
         [1] = number (number = 1)
         [2] = operatorSymbol (operatorSymbol = "+")
         [3] = number (number = 2)
         [4] = operatorSymbol (operatorSymbol = "*")
         [5] = number (number = 3)
         [6] = rightParenthesis
         [7] = operatorSymbol (operatorSymbol = "/")
         [8] = number (number = 4)
         
         We then run this through the infixToPostfix conversion that constructs
         the Postfix array, showing the order in which we want to evaluate the
         tokens:
         
         [0] = number (number = 1)
         [1] = number (number = 2)
         [2] = number (number = 3)
         [3] = operatorSymbol (operatorSymbol = "*")
         [4] = operatorSymbol (operatorSymbol = "+")
         [5] = number (number = 4)
         [6] = operatorSymbol (operatorSymbol = "/")
         
         Finally, we evaluate the expression in it's postfix form.
        */
        let tokens = try tokenize(expression: expression)
        let postfixTokens = infixToPostfix(tokens: tokens)
        return try evaluatePostfix(postfixTokens)
    }

    private func tokenize(expression: String) throws -> [Token] {
        var tokens = [Token]()
        var currentNumber = ""

        for char in expression {
            if char.isNumber || char == "." {
                currentNumber.append(char)
            } else {
                if !currentNumber.isEmpty {
                    tokens.append(.number(ResultType(currentNumber)!))
                    currentNumber = ""
                }

                switch char {
                case "+", "-", "*", "/":
                    tokens.append(.operatorSymbol(char))
                case "(":
                    tokens.append(.leftParenthesis)
                case ")":
                    tokens.append(.rightParenthesis)
                case " ":
                    continue  // Ignore spaces
                default:
                    throw EvaluationErrors.invalidCharacter(char: char)
                }
            }
        }

        // Add the last collected number if any
        if !currentNumber.isEmpty {
            tokens.append(.number(ResultType(currentNumber)!))
        }

        return tokens
    }

    private func precedence(of operatorSymbol: Character) -> Int {
        switch operatorSymbol {
        case "+", "-":
            return 1
        case "*", "/":
            return 2
        default:
            return 0
        }
    }

    private func infixToPostfix(tokens: [Token]) -> [Token] {
        var outputQueue = [Token]()
        var operatorStack = [Token]()

        for token in tokens {
            switch token {
            case .number:
                outputQueue.append(token)
            case .operatorSymbol(let oper):
                while let last = operatorStack.last, case .operatorSymbol(let lastOp) = last,
                      precedence(of: lastOp) >= precedence(of: oper) {
                    outputQueue.append(operatorStack.popLast()!)
                }
                operatorStack.append(token)
            case .leftParenthesis:
                operatorStack.append(token)
            case .rightParenthesis:
                while let last = operatorStack.last,
                        last != .leftParenthesis {
                    outputQueue.append(operatorStack.popLast()!)
                }
                _ = operatorStack.popLast()  // Remove the left parenthesis
            }
        }

        while let last = operatorStack.popLast() {
            outputQueue.append(last)
        }

        return outputQueue
    }

    private func evaluatePostfix(_ tokens: [Token]) throws -> ResultType {
        var stack = [ResultType]()

        for token in tokens {
            switch token {
            case .number(let value):
                stack.append(value)
            case .operatorSymbol(let oper):
                guard let right = stack.popLast() else { throw EvaluationErrors.incompleteFormula }
                guard let left = stack.popLast() else { throw EvaluationErrors.incompleteFormula }
                let result: ResultType
                switch oper {
                case "+":
                    result = left + right
                case "-":
                    result = left - right
                case "*":
                    result = left * right
                case "/":
                    if right == 0 { throw EvaluationErrors.divideByZero }
                    result = left / right
                default:
                    throw EvaluationErrors.unknownOperator(oper: oper)
                }
                stack.append(result)
            default:
                throw EvaluationErrors.unexpectedToken
            }
        }

        return stack.popLast()!
    }
}
