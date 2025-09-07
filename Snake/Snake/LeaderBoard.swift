//
// -----------------------------------------
// Original project: Snake
// Original package: Snake
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
        leaderBoard.smallLeaderBoard = []
        leaderBoard.mediumLeaderBoard = []
        leaderBoard.largeLeaderBoard = []
        saveLoaderBoard()
    }

    func addLeader(score: Int, forLevel level: SnakeGameSize) {
        // based on the game level, add the score to the leader board
        // if it is better than any other score.
        var requiresSave = false
        switch level {
        case .small:
            requiresSave = addScoreToSmall(score: score)
        case .medium:
            requiresSave = addScoreToMedium(score: score)
        case .large:
            requiresSave = addScoreToLarge(score: score)
        }

        // Save the leader board if we changed it.
        if requiresSave {
            saveLoaderBoard()
        }
    }

    private func addScoreToSmall(score: Int) -> Bool {
        if leaderBoard.smallLeaderBoard.count == 5 {
            // Get the smallest score and make sure the new score is greater than the old minimum.
            if let minScore = leaderBoard.smallLeaderBoard.min(by: { $0.gameScore < $1.gameScore }) {
                if score <= minScore.gameScore { return false }
            }
        }

        leaderBoard.smallLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.smallLeaderBoard.sorted(by: { $0.gameScore > $1.gameScore })

        leaderBoard.smallLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    private func addScoreToMedium(score: Int) -> Bool {
        if leaderBoard.mediumLeaderBoard.count == 5 {
            // Get the smallest score and make sure the new score is greater than the old minimum.
            if let minScore = leaderBoard.mediumLeaderBoard.min(by: { $0.gameScore < $1.gameScore }) {
                if score <= minScore.gameScore { return false }
            }
        }

        leaderBoard.mediumLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.mediumLeaderBoard.sorted(by: { $0.gameScore > $1.gameScore })

        leaderBoard.mediumLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    private func addScoreToLarge(score: Int) -> Bool {
        if leaderBoard.largeLeaderBoard.count == 5 {
            // Get the smallest score and make sure the new score is greater than the old minimum.
            if let minScore = leaderBoard.largeLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score <= minScore.gameScore { return false }
            }
        }

        leaderBoard.largeLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.largeLeaderBoard.sorted(by: { $0.gameScore > $1.gameScore })

        leaderBoard.largeLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    /// Load tghe leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "SnakeLeaderBoard")

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "SnakeLeaderBoard")

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
    var smallLeaderBoard: [LeaderBoardItem] = []
    var mediumLeaderBoard: [LeaderBoardItem] = []
    var largeLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    var gameDate: Date
    var gameScore: Int
}
