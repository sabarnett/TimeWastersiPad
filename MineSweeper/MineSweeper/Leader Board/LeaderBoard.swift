//
// -----------------------------------------
// Original project: MineSweeper
// Original package: MineSweeper
// Created on: 07/12/2024 by: Steven Barnett
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
        leaderBoard.beginnerLeaderBoard = []
        leaderBoard.intermediateLeaderBoard = []
        leaderBoard.expertLeaderBoard = []
        saveLoaderBoard()
    }

    func addLeader(score: Int, forLevel level: GameDifficulty) {
        // based on the game level, add the score to the leader board
        // if it is better than any other score.
        var requiresSave = false
        switch level {
        case .beginner:
            requiresSave = addScoreToBeginners(score: score)
        case .intermediate:
            requiresSave = addScoreToIntermediate(score: score)
        case .expert:
            requiresSave = addScoreToExpert(score: score)
        }

        // Save the leader board if we changed it.
        if requiresSave {
            saveLoaderBoard()
        }
    }

    private func addScoreToBeginners(score: Int) -> Bool {
        if leaderBoard.beginnerLeaderBoard.count == 5 {
            if let maxScore = leaderBoard.beginnerLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }

        leaderBoard.beginnerLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.beginnerLeaderBoard.sorted(by: { $0.gameScore < $1.gameScore })

        leaderBoard.beginnerLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    private func addScoreToIntermediate(score: Int) -> Bool {
        if leaderBoard.intermediateLeaderBoard.count == 5 {
            if let maxScore = leaderBoard.intermediateLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }

        leaderBoard.intermediateLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.intermediateLeaderBoard.sorted(by: { $0.gameScore < $1.gameScore })

        leaderBoard.intermediateLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    private func addScoreToExpert(score: Int) -> Bool {
        if leaderBoard.expertLeaderBoard.count == 5 {
            if let maxScore = leaderBoard.expertLeaderBoard.max(by: { $0.gameScore < $1.gameScore }) {
                if score >= maxScore.gameScore { return false }
            }
        }

        leaderBoard.expertLeaderBoard.append(LeaderBoardItem(gameDate: Date.now, gameScore: score))
        let newScores = leaderBoard.expertLeaderBoard.sorted(by: { $0.gameScore < $1.gameScore })

        leaderBoard.expertLeaderBoard = Array(newScores.prefix(5))
        return true
    }

    /// Load tghe leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "MineSweeperLeaderBoard")

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "MineSweeperLeaderBoard")

        // Json encode and save the file
        guard let encoded = try? JSONEncoder().encode(leaderBoard) else {
            return
        }

        try? encoded.write(to: saveFileUrl, options: .atomic)
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
    var beginnerLeaderBoard: [LeaderBoardItem] = []
    var intermediateLeaderBoard: [LeaderBoardItem] = []
    var expertLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()

    var gameDate: Date
    var gameScore: Int
}
