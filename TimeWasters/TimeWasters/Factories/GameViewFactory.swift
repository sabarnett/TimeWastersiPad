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

import AdventureGame
import MatchedPairs
import MineSweeper
import NumberCombinations
import Othello
import SharedComponents
import SwiftUI
import TicTacToe
import WordCraft
import WordSearch
import Snake

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
        case .othello:
            AnyView(OthelloView(gameData: game))
        case .adventure:
            AnyView(AdventureGameView(gameData: game, game: "adv08"))
        case .matchedPairs:
            AnyView(MatchedPairsView(gameData: game))
        case .wordSearch:
            AnyView(WordSearchView(gameData: game))
        case .snake:
            AnyView(SnakeGameView(gameData: game))
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
        case .othello:
            AnyView(Text("There are no settigs for Othello"))
        case .adventure:
            AnyView(Text("There are no settings for Pyramid of Doom"))
        case .matchedPairs:
            AnyView(MatchedPairsSettingsView())
        case .wordSearch:
            AnyView(WordSearchSettingsView())
        case .snake:
            AnyView(SnakeSettingsView())
        @unknown default:
            fatalError("Unable to determine game settings view")
        }
    }

}
