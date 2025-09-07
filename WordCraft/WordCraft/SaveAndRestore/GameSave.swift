//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 10/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

struct GameSave {

    /// Save the current game to a file so we can restore it later.
    ///
    /// - Parameter game: The game model to be saved
    ///
    /// Saving a game consists of saving a fixed number of items to a JSOn file. We
    /// need to save:
    ///
    ///
    func save(game: WordCraftViewModel) {
        // Get the save file name
        let saveFileTo = saveFileUrl("WordCraft")

        // Helper object for the save data
        var saveData = GameSaveData()

        // Save the game state  - the columns are saved as a flat array of strings
        saveData.usedWords = Array(game.usedWords)
        saveData.score = game.score
        saveData.letters = game.columns.flatMap { $0 }.map { $0.letter }

        // Json encode and save the file
        if let encoded = try? JSONEncoder().encode(saveData) {
            try? encoded.write(to: saveFileTo, options: .atomic)
        }
    }

    /// Restore a saved game
    ///
    /// - Parameter game: The game view model to be restored
    ///
    /// Restoring a saved game consists of reloading:
    ///
    ///
    func restore(game: WordCraftViewModel) {

        let loadFileFrom = saveFileUrl("WordCraft")
        guard let gameData = try? Data(contentsOf: loadFileFrom) else { return }
        guard let decodedData = try? JSONDecoder().decode(GameSaveData.self, from: gameData) else { return }

        // Put the used words list back
        game.usedWords.removeAll()
        for word in decodedData.usedWords {
            game.usedWords.insert(word)
        }

        game.score = decodedData.score
        game.selectedLetters.removeAll()

        // Restore the tiles - we have a flat array of strings that we use
        // to rebuild the tiles.
        let letters = decodedData.letters
        game.columns = [[Tile]]()

        for col in 0..<5 {
            var column = [Tile]()

            for idx in 0..<8 {
                let piece = Tile(column: col, letter: letters[col * 6 + idx])
                column.append(piece)
            }

            game.columns.append(column)
        }
    }

    /// Generate the file name to save the data to or to reload the data from.
    ///
    /// - Parameter gameDefinition: The definition of the game
    ///
    /// - Returns: The URL to use to save the file. It is based on the name of the
    /// game file and will be saved to the users document directory.
    private func saveFileUrl(_ gameDefinition: String) -> URL {
        let saveFileName = gameDefinition + ".save"
        return URL.documentsDirectory.appendingPathComponent(saveFileName)
    }

}

/// Helper object - this is what we will use to save the JSON data.
private struct GameSaveData: Codable {
    // Save game date
    var saveDate: Date = .now

    // Save the fields
    var usedWords: [String] = []
    var score: Int = 0
    var letters: [String] = []
}
