//
// -----------------------------------------
// Original project: Othello
// Original package: Othello
// Created on: 19/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import Foundation
import AVKit

extension OthelloViewModel {
    /// Play the background music
    func playBackgroundSound() {
        playSound(backgroundURL, repeating: true)
    }

    func playChime() {
        guard othelloPlaySounds else { return }

        chimeSound = try? AVAudioPlayer(contentsOf: chimeURL)
        if chimeSound != nil {
            chimeSound.numberOfLoops = 0
            self.chimeSound.play()
        }
    }

    /// If the background music is playing, stop it.
    func stopSounds() {
        if sounds != nil {
            sounds.stop()
        }
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        othelloPlaySounds.toggle()
    }

    func updateSounds() {
        speakerIcon = othelloPlaySounds ? "speaker.slash" : "speaker"

        if othelloPlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    func soundFile(named file: String) -> URL {
        let bun = Bundle(for: OthelloViewModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard othelloPlaySounds else { return }
        if sounds != nil {
            sounds.stop()
        }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            self.sounds.play()
        }
    }
}
