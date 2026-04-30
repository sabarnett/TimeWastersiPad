//
// -----------------------------------------
// Original project: WordCraft
// Original package: WordCraft
// Created on: 30/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import Foundation
import AVKit

extension WordCraftViewModel {

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
    func playTileDropSound() {
        guard wordcraftPlaySounds else { return }
        tileDrop = try? AVAudioPlayer(contentsOf: splatURL)
        tileDrop.play()
    }

    /// Toggle the playing of sounds. If toggled off, the current sound is stopped. If
    /// toggled on, then we start playing the ticking sound. It is unlikely that we were playing
    /// any other sound, so this is a safe bet.
    func toggleSounds() {
        wordcraftPlaySounds.toggle()
    }

    func updateSounds() {
        speakerIcon = wordcraftPlaySounds ? "speaker.slash" : "speaker"

        if wordcraftPlaySounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }

    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    func soundFile(named file: String) -> URL {
        let bun = Bundle(for: WordCraftViewModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    func playSound(_ url: URL, repeating: Bool = false) {
        guard wordcraftPlaySounds else { return }
        if sounds != nil { sounds.stop() }

        sounds = try? AVAudioPlayer(contentsOf: url)
        if sounds != nil {
            sounds.numberOfLoops = repeating ? -1 : 0
            self.sounds.play()
        }
    }
}
