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
import CodeMasters
import WanderingDigits
import Game2048

extension Game {
    @MainActor @ViewBuilder
    var gameView: some View {
        switch self {
        case .minesweeper:
            MinesweeperView(gameData: self)
        case .wordcraft:
            WordCraftView(gameData: self)
        case .numberCombinations:
            CombinationsView(gameData: self)
        case .ticTacToe:
            TicTacToeView(gameData: self)
        case .othello:
            OthelloView(gameData: self)
        case .adventure:
            AdventureGameView(gameData: self, game: "adv08")
        case .matchedPairs:
            MatchedPairsView(gameData: self)
        case .wordSearch:
            WordSearchView(gameData: self)
        case .snake:
            SnakeGameView(gameData: self)
        case .codeMaster:
            CodeMasterGameView(gameData: self)
        case .wanderingDigits:
            WanderingDigitsGameView(gameData: self)
        case .game2048:
            Game2048GameView(gameData: self)
        @unknown default:
            fatalError("Unable to determine game view")
        }
    }

    @MainActor @ViewBuilder
    var settingsView: some View {
        switch self {
        case .minesweeper:
            MinesweeperSettings()
        case .wordcraft:
            WordCraftSettingsView()
        case .numberCombinations:
            CombinationsSettingsView()
        case .ticTacToe:
            Text("There are no settings for Tic Tac Toe")
        case .othello:
            Text("There are no settigs for Othello")
        case .adventure:
            Text("There are no settings for Pyramid of Doom")
        case .matchedPairs:
            MatchedPairsSettingsView()
        case .wordSearch:
            WordSearchSettingsView()
        case .snake:
            SnakeSettingsView()
        case .codeMaster:
            CodeMasterSettingsView()
        case .wanderingDigits:
            WanderingDigitsSettingsView()
        case .game2048:
            Game2048SettingsView()
        @unknown default:
            fatalError("Unable to determine game settings view")
        }
    }
}

/// Single place to generate the game view or the game
/// settings view
struct GameViewFactory {

    @MainActor func gameView(for game: Game) -> some View {
        game.gameView
    }

    @MainActor func settingsView(for game: Game) -> some View {
        game.settingsView
    }
}
