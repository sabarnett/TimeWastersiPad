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

public class Counters {
    private let NCOUNTERS = 16      // The most that ScottFree save-game format supports

    private var counters: [Int] = [Int]()
    public var numberOfCounters: Int {
        return NCOUNTERS
    }

    init() {
        counters.removeAll()
        counters = [Int](repeating: 0, count: NCOUNTERS)
    }

    public func setCounter(atIndex: Int, toValue: Int) {
        checkIndexIsValid(atIndex)

        counters[atIndex] = toValue
    }

    public func getCounter(atIndex: Int) -> Int {
        checkIndexIsValid(atIndex)

        return counters[atIndex]
    }

    public func incrementCounter(atIndex: Int) {
        checkIndexIsValid(atIndex)
        counters[atIndex] += 1
    }

    public func decrementCounter(atIndex: Int) {
        checkIndexIsValid(atIndex)
        counters[atIndex] -= 1
    }

    public func addToCounter(atIndex: Int, theValue: Int) {
        checkIndexIsValid(atIndex)
        counters[atIndex] += theValue
    }
    public func subtractFromCounter(atIndex: Int, theValue: Int) {
        checkIndexIsValid(atIndex)
        counters[atIndex] -= theValue
    }

    subscript(atIndex: Int) -> Int {
        get {
            checkIndexIsValid(atIndex)
            return counters[atIndex]
        }
        set (newValue) {
            checkIndexIsValid(atIndex)
            counters[atIndex] = newValue
        }
    }

    private func checkIndexIsValid(_ index: Int) {
        if index >= 0 && index <= NCOUNTERS {
            return
        }

        fatalError("Invalid counter operation, supplied index '\(index)' is not valid.")
    }
}
