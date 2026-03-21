//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 17/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
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
        leaderBoard.leaderBoard = []
        saveLoaderBoard()
    }
    
    /// Adds the time taken and attempts count to the leader board and trim the
    /// list to the fastest 5 entries.
    ///
    /// - Parameters:
    ///   - timeTaken: Time taken to guess the correct formula
    ///   - attempts: How many attempts the player took.
    func addLeader(timeTaken: Int, attempts: Int) {
        // Add the new game time taken and attempts count to the
        // if it is better than any other score.
        addScoreToBoard(timeTaken: timeTaken, attempts: attempts)
        saveLoaderBoard()
    }

    private func addScoreToBoard(timeTaken: Int, attempts: Int) {
        leaderBoard.leaderBoard.append(
                LeaderBoardItem(gameDate: Date.now, gameScore: timeTaken, gameAttempts: attempts)
            )

        let newScores = leaderBoard.leaderBoard.sorted()
        leaderBoard.leaderBoard = Array(newScores.prefix(5))
    }

    /// Load the leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "WanderingDigitsLeaderBoard")

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "WanderingDigitsLeaderBoard")

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
    var leaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable, Comparable {
    var id: UUID = UUID()

    var gameDate: Date
    var gameScore: Int
    var gameAttempts: Int

    static func < (lhs: LeaderBoardItem, rhs: LeaderBoardItem) -> Bool {
        if lhs.gameScore != rhs.gameScore {
            return lhs.gameScore < rhs.gameScore
        }
        return lhs.gameAttempts < rhs.gameAttempts
    }
}
