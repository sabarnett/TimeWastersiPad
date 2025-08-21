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
import SharedComponents
import Observation

@Observable
class GamePlayViewModel {

    var gameDefinition: GameDefinition
    var game: Adventure
    var gameProgress = [GameDataRow]()
    var commandLine: String = ""
    var showGamePlay: Bool = false
    var gameOver: Bool = false
    var showResetConfirmation: Bool = false
    var showReloadConfirmation: Bool = false

    var notifyMessage: ToastConfig?

    init(game gameName: String) {
        let gamesList = GameDefinitions()
        self.gameDefinition = gamesList.game(forKey: gameName)!

        var optionSet = GameOptions()
        optionSet.bugTolerant = true

        game = Adventure(withOptions: optionSet)
        loadGame(fromFile: gameDefinition.file)

        game.displayText = showGameText
        game.displayPrompt = showPrompt
        game.initiliseGame()
        game.promptForTurn()
    }

    var carriedItems: [String] { game.carriedItems }
    var carriedItemsCount: Int { game.carriedItemsCount }
    var carriedItemsLimit: Int { game.gameHeader.maximumCarryItems }
    var treasureItems: [String] { game.treasures }
    var treasuresFound: Int { game.treasuresFound }

    /// Clear all game state and start the game again
    func restartGame() {
        gameProgress.removeAll()

        var optionSet = GameOptions()
        optionSet.bugTolerant = true

        game = Adventure(withOptions: optionSet)
        loadGame(fromFile: gameDefinition.file)

        game.displayText = showGameText
        game.displayPrompt = showPrompt
        game.initiliseGame()
        game.promptForTurn()
        gameOver = false

        notifyMessage = ToastConfig(message: "Game restored", type: .success)
    }

    /// Save the current state of the game so it can be restored later
    func saveGame() {
        let gameSaver = GameSave()
        gameSaver.save(game: game, progress: gameProgress, gameDefinition: gameDefinition)

        notifyMessage = ToastConfig(message: "Game saved", type: .success)
    }

    /// Clear the current state of the game and reload the last saved game details.
    func restoreGame() {
        let gameLoader = GameSave()
        gameLoader.restore(game: &game, progress: &gameProgress, gameDefinition: gameDefinition)

        notifyMessage = ToastConfig(message: "Game restored", type: .success)
    }

    /// Displays the text from the game.
    ///
    /// - Parameter message: The game generated message to display.
    private func showGameText(message: String) {
        gameProgress.append(GameDataRow(message: message, type: .consoleOutput))

        if game.finished {
            gameOver = true
        }
    }

    /// Sets the prompt text
    ///
    /// - Parameter message: The game generated prompt.
    private func showPrompt(message: String) {
        commandLine = ""
    }

    func consoleEnter() {
        let userInput = commandLine.trimmingCharacters(in: .whitespacesAndNewlines)
        if userInput.isEmpty { return }

        gameProgress.append(GameDataRow(message: userInput, type: .userInput))
        game.processTurn(command: userInput)

        commandLine = ""
    }

    private func loadGame(fromFile: String) {
        let bundle = Bundle(for: GamePlayViewModel.self)
        let fileUrl = bundle.url(forResource: fromFile, withExtension: "dat")

        if let jsFile = fileUrl {
            do {
                let gameData = try String(contentsOf: jsFile, encoding: .utf8)
                game.loadGame(fromData: gameData)
            } catch {
                print(error)
            }
        }
    }
}
