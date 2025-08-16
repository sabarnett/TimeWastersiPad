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

import MineSweeper
import SharedComponents
import SwiftUI
import WordCraft

/// Single place to generate the game view or the game
/// settings view
struct GameViewFactory {

    @MainActor func gameView(for game: Game) -> some View {
        switch game {
        case .minesweeper:
            AnyView(MinesweeperView(gameData: game))
        case .wordcraft:
            AnyView(WordCraftView(gameData: game))
        case .snake:
            AnyView(Text(game.gameDefinition.description))
        case .adventure:
            AnyView(Text(game.gameDefinition.description))
        case .numberCombinations:
            AnyView(Text(game.gameDefinition.description))
        case .ticTacToe:
            AnyView(Text(game.gameDefinition.description))
        case .othello:
            AnyView(Text(game.gameDefinition.description))
        case .matchedPairs:
            AnyView(Text(game.gameDefinition.description))
        case .wordSearch:
            AnyView(Text(game.gameDefinition.description))
        @unknown default:
            fatalError("Unable to determine game view")
        }
    }

    @MainActor func settingsView(for game: Game) -> some View {
        switch game {
        case .minesweeper:
            AnyView(MinesweeperSettings())
        case .wordcraft:
            AnyView(WordCraftSettingsView())
        case .snake:
            AnyView(Text("Snake settings"))
        case .adventure:
            AnyView(Text("Adventure settings"))
        case .numberCombinations:
            AnyView(Text("Number Combinations settings"))
        case .ticTacToe:
            AnyView(Text("Tic Tac Toe settings"))
        case .othello:
            AnyView(Text("Othello settings"))
        case .matchedPairs:
            AnyView(Text("Matched Pairs settings"))
        case .wordSearch:
            AnyView(Text("Word Search settings"))
        @unknown default:
            fatalError("Unable to determine game settings view")
        }
    }

}
