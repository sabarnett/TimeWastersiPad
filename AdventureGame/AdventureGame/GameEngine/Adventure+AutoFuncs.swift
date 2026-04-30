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

    public func autoGoTo(withVerb vIndex: Int, toLocationIndex nIndex: Int) -> Bool {

        if vIndex != VERBGO { return false }
        if nIndex < 1 || nIndex > 6 { return false }

        if isDark() {
            display(message: "It's dangerous to move in the dark...")
        }

        let newLocation = rooms[location].exits[nIndex - 1]
        if newLocation != 0 {
            location = newLocation
            needToLook = true
            actuallyLook()
        } else if isDark() {
            display(message: "I fell down and broke my neck.")
            finish(2)
        } else {
            display(message: "I can't go in that direction.")
        }

        return true
    }

    public func autoGet(withVerb: Int, itemWithIndex index: Int) -> Bool {
        if withVerb != VERBGET { return false }

        if index == 0 {
            display(message: "What?")
            return true
        }

        let noun = nouns[index].uppercased()

        let item = items.filter {
            $0.itemName.uppercased() == noun && $0.location == location
        }

        if item.count != 1 {
            display(message: "It is beyond my power to do that.")
        } else if carriedCount() == gameHeader.maximumCarryItems {
            display(message: "I already have too much to carry.")
        } else {
            item[0].location = ROOMCARRIED
            display(message: "Ok")
        }

        return true
    }

    public func autoDrop(withVerb: Int, itemWithIndex index: Int) -> Bool {
        if withVerb != VERBDROP { return false }

        if index == 0 {
            display(message: "What?")
            return true
        }

        let noun = nouns[index].uppercased()
        let item = items.filter {
            $0.itemName.uppercased() == noun && $0.location == ROOMCARRIED
        }

        if item.count != 1 {
            display(message: "It is beyond my power to do that.")
            return true
        }

        item[0].location = location
        display(message: "Ok")
        return true
    }
}
