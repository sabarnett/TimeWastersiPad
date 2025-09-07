//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 10/12/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

@Observable
class LeaderBoard {

    // Leader board by game level
    var leaderBoard: LeaderBoardData = LeaderBoardData()

    init () {
        loadLeaderBoard()
    }

    func clear() {
        leaderBoard.gameTimes = []
        saveLoaderBoard()
    }

    func addLeader(score: Int) {
        // Save the score to the high scores list if it is faster than
        // an existing entry
        if leaderBoard.gameTimes.count == 5 {
            if let maxScore = leaderBoard.gameTimes.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return }
            }
        }

        leaderBoard.gameTimes.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.gameTimes.sorted(by: { $0.gameScore < $1.gameScore })

        leaderBoard.gameTimes = Array(newScores.prefix(5))

        // Save the leader board if we changed it.
        saveLoaderBoard()
    }

    /// Load tghe leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "CombinationsLeaderBoard")

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "CombinationsLeaderBoard")

        // Json encode and save the file
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
    var gameTimes: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    var gameDate: Date
    var gameScore: Int
}
