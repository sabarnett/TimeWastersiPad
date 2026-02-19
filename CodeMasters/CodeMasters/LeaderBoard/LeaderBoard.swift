//
// -----------------------------------------
// Original project: CodeMaster
// Original package: CodeMaster
// Created on: 13/02/2026 by: Steven Barnett
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
        leaderBoard.easyLeaderBoard = []
        leaderBoard.mediumLeaderBoard = []
        leaderBoard.hardLeaderBoard = []
        leaderBoard.veryHardLeaderBoard = []
        saveLoaderBoard()
    }

    func addLeader(score: Int, forLevel level: CodeMasterGameLevel) {
        // based on the game level, add the score to the leader board
        // if it is better than any other score.
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

        case .veryhard:
            requiresSave = addLeaderBoard(score: score,
                                          to: &leaderBoard.veryHardLeaderBoard)
        default:
            requiresSave = false
        }

        // Save the leader board if we changed it.
        if requiresSave {
            saveLoaderBoard()
        }
    }

    /// Check the passed scores array to see if the new score should be added or discarded. If
    /// it should be added (i.e. it's a better score (lower) than one of the existing ones), then add the score
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

    /// Load tghe leader board from the saved JSON file, If the file doesn't exist
    /// we assume that no scores have been saved, so we go with the default
    /// initialisation.
    private func loadLeaderBoard() {
        let loadFileUrl = fileUrl(file: "CodeMasterLeaderBoard")

        guard let gameData = try? Data(contentsOf: loadFileUrl) else { return }
        guard let decodedData = try? JSONDecoder().decode(LeaderBoardData.self, from: gameData) else { return }

        leaderBoard = decodedData
    }

    /// Save the leader board to a JSON file.
    private func saveLoaderBoard() {
        let saveFileUrl = fileUrl(file: "CodeMasterLeaderBoard")

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
    var easyLeaderBoard: [LeaderBoardItem] = []
    var mediumLeaderBoard: [LeaderBoardItem] = []
    var hardLeaderBoard: [LeaderBoardItem] = []
    var veryHardLeaderBoard: [LeaderBoardItem] = []
}

struct LeaderBoardItem: Codable, Identifiable {
    var id: UUID = UUID()
    var gameDate: Date
    var gameScore: Int
}
