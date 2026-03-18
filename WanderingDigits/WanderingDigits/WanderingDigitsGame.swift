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

import SwiftUI
import AVKit

struct GameRow {
    var values: [String] = []
    var target: Int = 0

    init(values: [String]) {
        self.values = values
        self.target = Int(self.values.joined()) ?? 0
    }
}

@Observable
final class WanderingDigitsGame {

    @ObservationIgnored
    @AppStorage(Constants.wdPlaySounds) var wdPlaySounds = false {
        didSet {
            updateSounds()
        }
    }

    var showGamePlay = false
    var isGameOver = false
    var isPlaying = false
    var secondsElapsed = 0

    var gameBoard: [GameRow] = [
        GameRow(values: ["0"]),
        GameRow(values: ["0"]),
        GameRow(values: ["0"])
    ]

    var mathOperator: String = "+"
    var leaderBoard = LeaderBoard()

    func restart() {
        isGameOver = true
        isPlaying = false

        // TODO: setup the game
        secondsElapsed = 0

        // Generate numbers
        gameBoard.removeAll()
        gameBoard.append(generateNumber())
        gameBoard.append(generateNumber())
        gameBoard.append(generateNumber())
        mathOperator = ["+", "-"].randomElement() ?? "+"

        isGameOver = false
        isPlaying = true
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
        guard wdPlaySounds else { return }
        playSound(backgroundURL, repeating: true, volume: 0.3)
    }

    /// If the background music is playing, stop it.
    func stopSounds() {
        guard wdPlaySounds else { return }
        sounds.stop()
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playKeyboardSound() {
        guard wdPlaySounds else { return }
        key = try? AVAudioPlayer(contentsOf: keyURL)
        key.play()
    }

    /// Play the tile drop sound while the new tiles enter into the game play area. This
    /// will play over the top of the background sound.
    func playDingSound() {
        guard wdPlaySounds else { return }
        key = try? AVAudioPlayer(contentsOf: chimeURL)
        key.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        wdPlaySounds.toggle()
    }

    private func updateSounds() {
        speakerIcon = wdPlaySounds ? "speaker.slash" : "speaker"

        if wdPlaySounds {
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
        let bun = Bundle(for: WanderingDigitsGame.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false, volume: Float = 1) {
        guard wdPlaySounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            if volume != 1 { sounds.volume = volume }
            self.sounds.play()
        }
    }
}

extension WanderingDigitsGame {
    func generateNumber() -> GameRow {
        let count = Int.random(in: 3...5)
        var gameNumbers = (0..<count).map { _ in String(Int.random(in: 0...9)) }
        gameNumbers[0] = String(Int.random(in: 1...9))

        return GameRow(values: gameNumbers)
    }
}
