//
// -----------------------------------------
// Original project: TimeWasters
// Original package: TimeWasters
// Created on: 14/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SharedComponents
import SwiftUI

/// Single place to generate the game view or the game
/// settings view
struct GameViewFactory {

    func gameView(for game: Game) -> some View {
        switch game {
        case .minesweeper:
            Text(game.gameDefinition.description)
        case .wordcraft:
            Text(game.gameDefinition.description)
        case .snake:
            Text(game.gameDefinition.description)
        case .adventure:
            Text(game.gameDefinition.description)
        case .numberCombinations:
            Text(game.gameDefinition.description)
        case .ticTacToe:
            Text(game.gameDefinition.description)
        case .othello:
            Text(game.gameDefinition.description)
        case .matchedPairs:
            Text(game.gameDefinition.description)
        case .wordSearch:
            Text(game.gameDefinition.description)
        @unknown default:
            fatalError("Unable to determine game view")
        }
    }

    func settingsView(for game: Game) -> some View {
        switch game {
        case .minesweeper:
            Text("Minesweeper settings")
        case .wordcraft:
            Text("Wordcraft settings")
        case .snake:
            Text("Snake settings")
        case .adventure:
            Text("Adventure settings")
        case .numberCombinations:
            Text("Number Combinations settings")
        case .ticTacToe:
            Text("Tic Tac Toe settings")
        case .othello:
            Text("Othello settings")
        case .matchedPairs:
            Text("Matched Pairs settings")
        case .wordSearch:
            Text("Word Search settings")
        @unknown default:
            fatalError("Unable to determine game settings view")
        }
    }

}
