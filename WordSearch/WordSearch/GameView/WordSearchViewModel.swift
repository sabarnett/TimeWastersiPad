//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 03/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import AVKit
import SharedComponents

enum GameState {
    case playing
    case endOfGame
}

@Observable
class WordSearchViewModel {

    @ObservationIgnored
    @AppStorage(Constants.wordsearchPlaySounds) private var wordsearchPlaySounds = true {
        didSet {
            updateSounds()
        }
    }

    @ObservationIgnored
    @AppStorage(Constants.wordsearchAllowShowHints) private var allowShowHints = true

    @ObservationIgnored
    @AppStorage(Constants.wordsearchDifficulty) var gameDifficulty: Difficulty = .easy

    @ObservationIgnored
    private var dictionary: [String]

    private var startSelection: Letter?

    var words: [Word] = []
    var gameBoard: [[Letter]] = []
    var matchedWords: [MatchedWord] = []
    var gameState: GameState = .playing
    var speakerIcon: String = "speaker.fill"
    var hintsIcon: String = "eye.fill"
    var secondsElapsed: Int = 0
    var leaderBoard = LeaderBoard()

    init() {
        dictionary = Array(Dictionary(size: .medium).filtered(wordMinLength: 3, wordMaxLength: 12))
        newGame()
    }

    /// Create a new game, new words, new letters and reset the timer.
    func newGame() {
        matchedWords = []
        words = []
        gameBoard = []
        secondsElapsed = 0

        generateRandomWords()
        generateGameGrid()

        speakerIcon = wordsearchPlaySounds ? "speaker.slash.fill" : "speaker.fill"
        gameState = .playing
    }

    /// Toggle the ability to show hints using the keyboard
    func allowHints() {
        allowShowHints.toggle()
        hintsIcon = allowShowHints ? "eye.fill" : "eye.slash.fill"
    }

    /// Locate every occurence of a letter and set it's selected property to true causing it to be highlighted.
    ///
    /// - Parameter letter: The letter to select
    ///
    /// The selections will reset after 2 seconds. There is a 10 second time penalty for using this cheat.
    @MainActor
    func hilightLetter(letter: Character) {
        guard allowShowHints == true else { return }

        secondsElapsed += 10
        clearSelectedLetters()
        startSelection = nil

        selectAllLetters(letter: letter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.clearSelectedLetters()
        }
    }

    /// Find all tiles marked as selected and turn off the selection status
    fileprivate func clearSelectedLetters() {
        let currentlyMarked = gameBoard.flatMap { $0 }
            .filter { $0.selected == true }
        for matched in currentlyMarked {
            matched.selected = false
        }
    }

    /// Find all occurrences of the selected letter and turn on its selection status
    ///
    /// - Parameter letter: The letter to locate.
    fileprivate func selectAllLetters(letter: Character) {
        let markedLetters = gameBoard.flatMap { $0 }
            .filter { $0.letter.uppercased() == letter.uppercased() }

        for matched in markedLetters {
            matched.selected = true
        }
    }

    /// Player has selected a letter. We need to determine whether this is the second letter selected
    /// and, if it is, whether the player has selected one of the words from our word list.
    ///
    /// - Parameter letter: The letter the player selected
    ///
    /// We have a lot of work to do here. Firt thing to do is determine whether they want to deselect the
    /// currently selected letter. If they click the same letter twice, we need to just deselect that letter.
    ///
    /// Next we need to validate the selection. If this is the first selection, then it's automatically valid but,
    /// if this is the second letter selected, we need to make sure it aligns in a straight line with the
    /// first letter selected.
    ///
    /// Finally, we can select the letter. If this is the first letter in the selection, then we can select it and bow
    /// out of the selection. We have no further checks to make.
    ///
    /// If this is the second letter selecte, i.e. the end of the word, we need to check that the player has
    /// selected one of our game words. If it's not a game word, then we can ignore the players selection
    /// because it's not valid. If it matches one of our words, we can mark the word as found and check
    /// for end of game.
    func select(letter: Letter) {
        guard gameState == .playing else { return }

        if deselect(letter: letter) == true { return }
        if validateSelection(letter: letter) == false { return }
        if selectStartLetter(letter) == true { return }

        if let startSelection {
            let selectedWord = selectLettersBetween(start: startSelection, end: letter)
            if let selection = wordSelected(playerWord: selectedWord) {
                selection.found = true

                matchedWords.append(
                    MatchedWord(startLetter: startSelection, endLetter: letter)
                )

                gameBoard[startSelection.xPos][startSelection.yPos].selected = false
                letter.selected = false
                self.startSelection = nil

                playChimeSound()

                checkForEndOfGame()
            }
        }
    }

    /// Generates a list of words to place in the grid for the players to find.
    private func generateRandomWords() {
        for _ in 0..<Constants.wordCount {
            if let randomWord = dictionary.randomElement() {
                words.append(Word(randomWord))
            }
        }
    }

    /// Generate the game grid, placing the words on the grid and random letters
    /// in any unused spaces.
    private func generateGameGrid() {
        let words = self.words.map { $0.word }
        let wSearch = WordSearch(words: words, difficulty: gameDifficulty)
        let letters = wSearch.makeGrid()

        // We're going to build this thing column by column where each column contains
        // 14 items representing the values in the row.
        for column in 0..<Constants.tileCountPerRow {
            // Each of these represents a column
            var rowValues: [Letter] = []

            for row in 0..<Constants.tileCountPerRow {
                let current = letters[column][row].letter
                rowValues.append(Letter(letter: current, xPos: column, yPos: row))
            }
            // Add the column to the array of columns.
            gameBoard.append(rowValues)
        }
    }

    /// If the letter is selected, deselect it. Also check if this is the currently selected start letter
    /// and, if it is, clear the selection. If the letter isn't selected, do nothing.
    ///
    /// - Parameter letter: The letter to test
    /// - Returns: True if the letter was deselected else false
    private func deselect(letter: Letter) -> Bool {
        if letter.selected == false { return false }

        gameBoard[letter.xPos][letter.yPos].selected = false
        if let startSelection, startSelection.id == letter.id {
            self.startSelection = nil
        }
        return true
    }

    /// Validate the letter selection.
    /// - Parameter letter: The letter to validate
    /// - Returns: True if the selection is valid, else false
    ///
    /// The letter is valid if it is the first item selected. If we already have an
    /// initial letter selected, then we need to make sure that the letter will form
    /// a straight line vertically, horizontally or diagonally to the start letter. if
    /// it does not form a straight line, then it cannot be used to select a word.
    private func validateSelection(letter: Letter) -> Bool {
        guard let startSelection = self.startSelection else { return true }

        // Horizontal Line
        if startSelection.yPos == letter.yPos { return true }

        // Vertical Line
        if startSelection.xPos == letter.xPos { return true }

        // Diagonal Line
        if abs(startSelection.xPos - letter.xPos) == abs(startSelection.yPos - letter.yPos) {
            return true
        }

        // Not connected by any straight line
        return false
    }

    /// Checks whether we have a start letter and, if not, sets it to the passed letter. If we
    /// already have a start letter, does noting.
    ///
    /// - Parameter letter: The letter to select as the start letter
    /// - Returns: True if we already have a start letter selected, else false
    private func selectStartLetter(_ letter: Letter) -> Bool {
        if startSelection != nil { return false }

        self.startSelection = letter
        gameBoard[letter.xPos][letter.yPos].selected = true
        return true
    }

    /// Selects all the letters between the start cell and the end cell.
    ///
    /// - Parameters:
    ///   - start: The starting letter
    ///   - end: The ending letter
    ///
    /// - Returns: A string containing all the letters
    private func selectLettersBetween(start startLetter: Letter, end endLetter: Letter) -> String {

        var xIterator = 0
        var yIterator = 0

        if startLetter.xPos != endLetter.xPos {
            xIterator = startLetter.xPos < endLetter.xPos ? 1 : -1
        }

        if startLetter.yPos != endLetter.yPos {
            yIterator = startLetter.yPos < endLetter.yPos ? 1 : -1
        }

        var word: [String] = []
        var xPos = startLetter.xPos
        var yPos = startLetter.yPos

        while xPos != endLetter.xPos || yPos != endLetter.yPos {
            word.append(String(gameBoard[xPos][yPos].letter))

            xPos += xIterator
            yPos += yIterator
        }
        word.append(String(endLetter.letter))

        return word.joined()
    }

    /// Checks whether the owrd we have been passed matches one of the words the players
    /// are trying to locate.
    ///
    /// - Parameter playerWord: The word the player has highlighted
    /// - Returns: The word that matched else nil of the word is not in the list.
    private func wordSelected(playerWord: String) -> Word? {
        for word in words.filter({ $0.found == false }) {
            let checkWord = playerWord
            let checkWordReversed = String(playerWord.reversed())

            if word.word.caseInsensitiveCompare(checkWord) == .orderedSame ||
                word.word.caseInsensitiveCompare(checkWordReversed) == .orderedSame {
                return word
            }
        }
        return nil
    }

    /// Checks whether all words have been found
    private func checkForEndOfGame() {
        if words.count(where: {$0.found == false}) == 0 {
            leaderBoard.addLeader(score: secondsElapsed, for: gameDifficulty)
            gameState = .endOfGame
        }
    }

    // MARK: - Souond functions

    private var sounds: AVAudioPlayer!
    private var tileDrop: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var chimeURL: URL { soundFile(named: "chime") }

    /// Play the background music
    func playBackgroundSound() {
        if sounds != nil { stopSounds() }
        playSound(backgroundURL, repeating: true)
    }

    /// If the background music is playing, stop it.
    func stopSounds() {
        if sounds != nil {
            sounds.stop()
        }
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playChimeSound() {
        guard wordsearchPlaySounds else { return }
        tileDrop = try? AVAudioPlayer(contentsOf: chimeURL)
        tileDrop.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        wordsearchPlaySounds.toggle()
    }

    private func updateSounds() {
        speakerIcon = wordsearchPlaySounds ? "speaker.slash.fill" : "speaker.fill"

        if wordsearchPlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: WordSearchViewModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard wordsearchPlaySounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            self.sounds.play()
        }
    }
}
