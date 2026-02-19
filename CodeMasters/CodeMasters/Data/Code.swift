//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 14/02/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct Code: Equatable {
    var kind: Kind
    var pegs: [Peg]

    static func ==(lhs: Code, rhs: Code) -> Bool {
        lhs.pegs == rhs.pegs
    }

    enum Kind: Equatable {
        case master(reveal: Bool)
        case guess
        case attempt([Match])
        case unknown
    }

    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): return matches
        default: return nil
        }
    }

    init(kind: Kind, pegCount: Int) {
        self.kind = kind
        self.pegs = Array(repeating: Peg.missing, count: pegCount)
    }

    mutating func randomize(from pegChoices: [Peg] = ["red", "blue", "green"]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Peg.missing
        }
    }

    func match(against otherCode: Code) -> [Match] {

        var pegsToMatch = otherCode.pegs

        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                // Right peg, right place
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }

        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
    }
}
