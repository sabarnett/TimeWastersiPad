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

import SwiftUI
import AVKit
import Combine

enum CodeMasterGameLevel: String, Identifiable, CaseIterable, CustomStringConvertible  {
    case random, easy, medium, hard, veryhard

    var id: String { rawValue }

    var description: String {
        switch self {
        case .random: return "Random"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        case .veryhard: return "Very Hard"
        }
    }

    static var randomLevel: CodeMasterGameLevel {
        while(true) {
            if let randomLevel = CodeMasterGameLevel.allCases.randomElement(),
               randomLevel != .random {
                return randomLevel
            }
        }
    }

    var pegCount: Int {
        switch self {
        case .random:
            Int.random(in: 3...6)
        case .easy:
            3
        case .medium:
            4
        case .hard:
            5
        case .veryhard:
            6
        }
    }
}

class CodeMasterGame: ObservableObject {

    @AppStorage(Constants.cmPlaySounds) var cmPlaySounds = false {
        didSet {
            updateSounds()
        }
    }

    @AppStorage(Constants.cmGameLevel) var cmGameLevel: CodeMasterGameLevel = .medium
    @AppStorage(Constants.cmGameTheme) var cmGameTheme: String = Themes.Random

    var leaderBoard: LeaderBoard = LeaderBoard()

    @Published var showGamePlay: Bool = false
    @Published var isGameOver = false

    @Published var masterCode: Code = Code(kind: .master(reveal: false), pegCount: 4)
    @Published var guess: Code = Code(kind: .guess, pegCount: 4)
    @Published var attempts = [Code]()
    @Published var pegChoices = [Peg]()
    @Published var themeName: String = "None"
    @Published var pegCount: Int = 4
    @Published var gameLevel: CodeMasterGameLevel = .easy

    var canGuess: Bool {
        // Cannot guess until all pegs have a value
        if guess.pegs.count(where: {$0 == .missing}) > 0 { return false }

        // do these pegs match a previous guess? If any match, we cannot guess
        for attempt in attempts {
            if attempt == guess { return false }
        }

        return true
    }

    init() {
        self.restart()
    }

    func changeGuessPeg(at index: Int, to: Peg) {
        guess.pegs[index] = to
    }

    func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)

        if attempt == masterCode {
            leaderBoard.addLeader(score: attempts.count, forLevel: gameLevel)
            masterCode.kind = .master(reveal: true)
            isGameOver = true
            stopSounds()
            return
        }

        guess = Code(kind: .guess, pegCount: pegCount)
    }

    func restart() {
        setTheme()
        setGameLevel()
        clearAttemptsAndGuess()
        setMasterCode()

        speakerIcon = cmPlaySounds ? "speaker.slash" : "speaker"
        playBackgroundSound()

        isGameOver = false
    }

    fileprivate func setTheme() {
        let themes = Themes()

        let theme = cmGameTheme == Themes.Random
        ? themes.randomTheme
        : themes.theme(named: cmGameTheme) ?? themes.randomTheme

        self.themeName = theme.name
        self.pegChoices = theme.items
    }

    fileprivate func setGameLevel() {
        gameLevel = cmGameLevel
        if gameLevel == .random {
            gameLevel = CodeMasterGameLevel.randomLevel
        }
        pegCount = gameLevel.pegCount
    }

    fileprivate func clearAttemptsAndGuess() {
        attempts = [Code]()
        guess = Code(kind: .guess, pegCount: pegCount)
    }

    fileprivate func setMasterCode() {
        masterCode = Code(kind: .master(reveal: false), pegCount: pegCount)
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }


    // MARK: - Souond functions

    private var sounds: AVAudioPlayer!
    private var key: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var keyURL: URL { soundFile(named: "splat") }
    private var chimeURL: URL { soundFile(named: "chime") }
    var speakerIcon: String = "speaker"

    /// Play the background music
    func playBackgroundSound() {
        guard cmPlaySounds else { return }
        playSound(backgroundURL, repeating: true, volume: 0.3)
    }

    /// If the background music is playing, stop it.
    func stopSounds() {
        guard cmPlaySounds else { return }
        sounds.stop()
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playKeyboardSound() {
        guard cmPlaySounds else { return }
        key = try? AVAudioPlayer(contentsOf: keyURL)
        key.play()
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playDingSound() {
        guard cmPlaySounds else { return }
        key = try? AVAudioPlayer(contentsOf: chimeURL)
        key.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        cmPlaySounds.toggle()
    }

    private func updateSounds() {
        speakerIcon = cmPlaySounds ? "speaker.slash" : "speaker"

        if cmPlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            if sounds != nil {
                sounds.numberOfLoops = 0
                sounds.currentTime = 0
                sounds.stop()
            }
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: CodeMasterGame.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false, volume: Float = 1) {
        guard cmPlaySounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            if volume != 1 { sounds.volume = volume }
            self.sounds.play()
        }
    }
}
