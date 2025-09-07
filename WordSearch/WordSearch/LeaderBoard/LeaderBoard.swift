//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 04/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class LeaderBoard {

    private var leaderBoard: LeaderBoardData = LeaderBoardData()

    var easyLeaderBoard: [LeaderBoardItem] { leaderBoard.easyLeaderBoard }
    var mediumLeaderBoard: [LeaderBoardItem] { leaderBoard.mediumLeaderBoard }
    var hardLeaderBoard: [LeaderBoardItem] { leaderBoard.hardLeaderBoard }

    init () {
        loadLeaderBoard()
    }

    /// Adds a score to the leader board at the game difficulty level if it is better than
    /// one of the existing high scores. The best five scores are retained for each of
    /// the game levels.
    ///
    /// - Parameters:
    ///   - score: The score to be added if it beats one of the saved scores.
    ///   - level: The game difficulty level to add the score to.
    func addLeader(score: Int, for level: Difficulty) {
        var requiresSave = false

        switch level {
        case .easy:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.easyLeaderBoard)
        case .medium:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.mediumLeaderBoard)
        case .hard:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.hardLeaderBoard)
        }

        if requiresSave {
            saveLoaderBoard()
        }
    }

    /// Emptys the saved leader board scores.
    func clear() {
        leaderBoard.mediumLeaderBoard.removeAll()
        leaderBoard.easyLeaderBoard.removeAll()
        leaderBoard.hardLeaderBoard.removeAll()
        saveLoaderBoard()
    }

    /// Check the passed scores array to see if the new score should be added or discarded. If
    /// it should be added (i.e. it's a better score than one of the existing ones), then add the score
    /// and truncate the leader board arry to five items.
    ///
    /// If there are less than five items in the current list, the score will be added without any checks.
    ///
    /// - Parameters:
    ///   - score: The score to be potentially added.
    ///   - scores: The current array of leader board scores.
    ///
    /// - Returns: A bool value; true if the score was added so the list needs to be saved
    /// else false if no save is required.
    private func addLeaderBoard(score: Int, to scores: inout [LeaderBoardItem]) -> Bool {
        if scores.count == 5 {
            if let maxScore = scores.max(by: { $0.gameScore > $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }

        let scoreItem = LeaderBoardItem(gameDate: Date.now, gameScore: score)

        scores.append(scoreItem)
        scores.sort(by: {$0.gameScore < $1.gameScore})
        if scores.count > 5 {
            scores.removeLast()
        }

        return true
    }

    /// Load the leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: Constants.leaderBoardFileName)

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: Constants.leaderBoardFileName)

        if let encoded = try? JSONEncoder().encode(leaderBoard) {
            try? encoded.write(to: saveFileUrl, options: .atomic)
        }
    }

    /// Generate the file name to save the data to or to reload the data from.
    ///
    /// - Parameter gameDefinition: The definition of the game
    ///
    /// - Returns: The URL to use to save the file. It is based on the name of the
    /// game file and will be saved to the users document directory.
    private func fileUrl(file: String) -> URL {
        let fileName = file + ".save"
        return URL.documentsDirectory.appendingPathComponent(fileName)
    }
}

struct LeaderBoardData: Codable {
    var easyLeaderBoard: [LeaderBoardItem] = []
    var mediumLeaderBoard: [LeaderBoardItem] = []
    var hardLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    var gameDate: Date
    var gameScore: Int
}
