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
import NumberCombinations
import SharedComponents
import SwiftUI
import TicTacToe
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
        case .numberCombinations:
            AnyView(CombinationsView(gameData: game))
        case .ticTacToe:
            AnyView(TicTacToeView(gameData: game))
        case .snake:
            AnyView(Text(game.gameDefinition.description))
        case .adventure:
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
        case .numberCombinations:
            AnyView(CombinationsSettingsView())
        case .ticTacToe:
            AnyView(Text("There are no settings for Tic Tac Toe"))
        case .snake:
            AnyView(Text("Snake settings"))
        case .adventure:
            AnyView(Text("Adventure settings"))
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
