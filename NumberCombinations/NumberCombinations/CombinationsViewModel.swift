//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents
import AVKit

@Observable
class CombinationsViewModel {

    /// The four numbers that are used to achieve the result
    var values: [FormulaValue] = [
        FormulaValue(0),
        FormulaValue(0),
        FormulaValue(0),
        FormulaValue(0)
    ]

    /// The expected result from the calculation
    var result: FormulaValue = FormulaValue(0)

    /// The result of the formula as the user enters it - it's supposed to help!
    var interimResult: Int = 0

    /// Error messages for the formula as the user enters it
    var formulaErrors: String = ""

    /// The user entered formula. We trap didSet so we can extract the
    /// numbers in the formula and adjust the state of the numbers shown
    /// on the screen.
    var formula: String = "" {
        didSet {
            formulaErrors = ""
            interimResult = 0
            validateFormula()
        }
    }

    /// Contains the formula we used to achieve the result. Note, this is not
    /// necessarily the formula the player will create. There may be more than one
    /// solution to the puzzle.
    var usedFormula: String = ""

    /// Used to show the game play or leader board popovers
    var showGamePlay: Bool = false
    var showLeaderBoard: Bool = false

    /// Indicates that the game has been completed successfully.
    var success: Bool = false

    /// Determines which icon we need to use oon the tool bar for toggling the sounds
    var speakerIcon: String = "speaker"

    /// Tracks the start of the puzzle
    var gameStart: Date?

    @ObservationIgnored
    var leaderBoard = LeaderBoard()

    var notifyMessage: ToastConfig?

    @ObservationIgnored
    @AppStorage(Constants.ncPlaySounds) private var playSounds = true {
        didSet {
            updateSounds()
        }
    }

    /// Generates a new puzzle by generating four numbers between 1 and 10 and a random
    /// formula. We then calculate the return from the formula and make this the target the
    /// player needs to achieve. All arithmetic is integer arithmetic, so dividing 3 by 2 results in 1.
    ///
    /// Now, we could use random numbers, but that gives us the possibility of getting the same
    /// number three or four times. That's not going to be a challenge. So, I use an array or ints,
    /// shuffled into random order. This way, we get rour digits but can never have the same number
    /// more than twice.
    func generatePuzzle() {
        let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                       1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        let gameNumbers = numbers.shuffled()

        values = [
            FormulaValue(gameNumbers[0]),
            FormulaValue(gameNumbers[1]),
            FormulaValue(gameNumbers[2]),
            FormulaValue(gameNumbers[3])
        ]

        let generator = FormulaBuilder()
        if let (formula, calculatedResult) = generator.generateRandomFormula(values: values) {
            usedFormula = formula
            result = FormulaValue(calculatedResult)
        } else {
            // This should never happen - famous last words. If it does
            // lets not die, lets just go with a very simple formula.
            usedFormula = "\(values[0].value) + \(values[1].value  + values[2].value  + values[3].value)"
            result = FormulaValue(values[0].value + values[1].value + values[2].value + values[3].value)
        }

        formula = ""
        success = false
        speakerIcon = playSounds ? "speaker.slash" : "speaker"
        playBackgroundSound()

        gameStart = .now
    }

    // MARK: - Formula parsing to highlight selected numbers

    /// Takes the user entered formula and attempts to evaluate it. If we can calculate
    /// a result, we display this to help the user. If we can't evaluate the formula, we
    /// display an appropriate message.
    private func validateFormula() {
        if formula.isEmpty { return }
        if success { return }

        let numbers = getFormulaNumbers()
        setInUseIndicators(numbers: numbers)

        let eval = FormulaEvaluator()
        do {
            let result = try eval.evaluate(expression: formula)
            self.interimResult = result
        } catch EvaluationErrors.invalidCharacter(let character) {
            self.formulaErrors = "Invalid character: \(character)"
        } catch EvaluationErrors.unknownOperator(let oper) {
            self.formulaErrors = "Unknown operator: \(oper)"
        } catch EvaluationErrors.unexpectedToken {
            self.formulaErrors = "Invalid input characters"
        } catch EvaluationErrors.divideByZero {
            self.formulaErrors = "Can't divide by zero"
        } catch EvaluationErrors.incompleteFormula {
            self.formulaErrors = "Incomplete formula"
        } catch {
            self.formulaErrors = error.localizedDescription
        }

        // Right result and all numbers used?
        if interimResult == result.value
            && values.allSatisfy(\.isUsed)
            && formula.count(where: { $0 == "(" }) == formula.count(where: {$0 == ")"}) {
            success = true

            let gameEnd = Date.now
            let gameDuration = gameEnd.timeIntervalSince(gameStart!)
            let gameSeconds = Int(gameDuration)

            // Log the result in the leader board
            leaderBoard.addLeader(score: gameSeconds)

            stopSounds()
            playSuccessSound()
        }
    }

    private func getFormulaNumbers() -> [String] {
        guard let regex = try? NSRegularExpression(pattern: "\\d+", options: []) else { return [] }

        let matches = regex.matches(in: formula,
                                    options: [],
                                    range: NSRange(formula.startIndex..<formula.endIndex,
                                                   in: formula))
        let numbers = matches.map {
            String(formula[Range($0.range, in: formula)!])
        }

        return numbers
    }

    private func setInUseIndicators(numbers: [String]) {
        for index in 0..<values.count {
            values[index].isUsed = false
        }

        for match in numbers {
            let number = Int(match)
            if let displayItem = values.firstIndex(where: { $0.value == number && !$0.isUsed }) {
                values[displayItem].isUsed = true
            }
        }
    }

    func showSolution() {
        notifyMessage = ToastConfig(
            title: "Formula",
            message: usedFormula,
            icon: "squareshape.split.2x2",
            type: .info,
            showDuration: 5
        )
    }

    // MARK: - Souond functions

    private var sounds: AVAudioPlayer!
    private var tileDrop: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var successURL: URL { soundFile(named: "success") }

    /// Play the background music
    func playBackgroundSound() {
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
    func playSuccessSound() {
        guard playSounds else { return }
        tileDrop = try? AVAudioPlayer(contentsOf: successURL)
        tileDrop.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        playSounds.toggle()
    }

    private func updateSounds() {
        speakerIcon = playSounds ? "speaker.slash" : "speaker"

        if playSounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: CombinationsViewModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard playSounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            self.sounds.play()
        }
    }
}

struct FormulaValue {

    var value: Int
    var isUsed: Bool = false

    init(_ value: Int) {
        self.value = value
    }

    var color: Color {
        isUsed ? .gray : .blue
    }
}
