//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 20/01/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI
import AVFoundation

enum GameState {
    case playing
    case gameOver
}

@Observable
class MatchedPairsGameModel {
    @ObservationIgnored
    @AppStorage(Constants.playSound) var playSounds = true {
        didSet {
            updateSounds()
        }
    }
    
    @ObservationIgnored
    @AppStorage(Constants.gameDifficulty) var gameDifficulty: GameDifficulty = .easy
    
    @ObservationIgnored
    @AppStorage(Constants.cardBackground) private var cardBg: CardBackgrounds = .one

    var leaderBoard = LeaderBoard()
    var tiles: [Tile] = []
    var columns: Int = 6
    var rows: Int = 4
    var gameState: GameState = .playing
    var cardBackground: String { cardBg.cardImage }
    var moves: Int = 0
    var time: Int = 0

    /// Determines which icon we need to use on the tool bar for toggling the sounds
    var speakerIcon: String = Constants.soundsOn

    init() {
        newGame()
    }
    
    /// Starts a new game, generating a new card deck and a new card background. It
    /// resets the score and the timer.
    func newGame() {
        columns = gameDifficulty.columns
        rows = gameDifficulty.rows
        
        tiles.removeAll(keepingCapacity: true)
        tiles = gameTiles()
        
        moves = 0
        time = 0
        
        gameState = .playing

        speakerIcon = playSounds ? Constants.soundsOff : Constants.soundsOn
        playBackgroundSound()
    }
    
    /// Creates the tiles for a new game. Each tile will be generated with a card face
    /// name and will be initialised face fown. The number of tiles depends on the
    /// game board size. There will always be two tiles generated per card.
    ///
    /// - Returns: The array of tiles for this game.
    private func gameTiles() -> [Tile] {
        let cardNames: [String] = allPotentialCards()

        // 10x6 grid of tiles
        var tileSetup: [Tile] = []
        for i in 0..<(columns*rows)/2 {
            let tileOne = Tile(face: cardNames[i])
            tileSetup.append(tileOne)
            let tileTwo = Tile(face: cardNames[i])
            tileSetup.append(tileTwo)
        }
        
        return tileSetup.shuffled()
    }
    
    /// Generate a list of the names of all of the potential cards we could have in
    /// this game. Cards will have a suit name (heart, club, diamond, spade) an
    /// underscore and a two digit card value between 01 and 13 (ace thru
    /// jack, queen, king).
    ///
    /// - Returns: An array of all potential card names we could use in this game,
    /// shuffled into a random order.
    private func allPotentialCards() -> [String] {
        var cardNames: [String] = []
        
        for suit in ["heart", "club", "diamond", "spade"] {
            for value in 1..<13 {
                cardNames.append("\(suit)_\(String(format: "%02d", value))")
            }
        }
        
        return cardNames.shuffled()
    }
    
    /// We have face down card images numbered _01 thru _05. Generate the name of
    /// one of these card images for the new game.
    ///
    /// - Returns: The name of the 'face down' card image.
    private func randomBackground() -> String {
        let background = Int.random(in: 1...5)
        return "back_\(String(format: "%02d", background))"
    }
    
    /// Player selected a tile on the game board. Make sure the game is still playing and that
    /// the file exists (should never not exist) before toggling it to face up. If we currently have
    /// two cards face up, turn them doen - we cannot ever have more than two face up cards.
    ///
    /// - Parameter tile: The tile the player clicked on
    func select(_ tile: Tile) {
        guard gameState == .playing,
                tile.isMatched == false,
                tile.isFaceUp == false,
                let tileIndex = tiles.firstIndex(where: {$0.id == tile.id}) else { return }
        
        moves += 1
        turnCardsDownIfRequired()
        
        tiles[tileIndex].isFaceUp = true
        checkForMatch()
        checkForEndOfGame()
    }
    
    /// Locates the selected card and turns it face down.
    ///
    /// - Parameter tile: The tile to change
    func turnFaceDown(_ tile: Tile) {
        guard gameState == .playing,
                tile.isMatched == false,
                tile.isFaceUp == true,
                let tileIndex = tiles.firstIndex(where: {$0.id == tile.id}) else { return }

        tiles[tileIndex].isFaceUp = false
    }
    
    /// If the user has two cards face up and taps a third card, the previous
    /// two cards must be turned face down.
    private func turnCardsDownIfRequired() {
        let indexes = tiles.enumerated().compactMap { $1.isFaceUp ? $0 : nil }
        
        if indexes.count == 2 {
            for index in indexes {
                tiles[index].isFaceUp = false
            }
        }
    }
    
    /// Do we have two cards face up and, if we do, are they the same card?
    private func checkForMatch() {
        let indexes = tiles.enumerated().compactMap { $1.isFaceUp ? $0 : nil }
        if indexes.count != 2 { return }
        
        if tiles[indexes[0]].face != tiles[indexes[1]].face { return }
        
        // We have a match - update both cards
        playChime()
        tiles[indexes[0]].match()
        tiles[indexes[1]].match()
    }
    
    /// Check for the end of the game. That's when all cards are marked as matched
    private func checkForEndOfGame() {
        if tiles.allSatisfy({$0.isMatched}) {
            gameState = .gameOver
            leaderBoard.addLeader(score: time, for: gameDifficulty)
            stopSounds()
        }
    }

    // MARK: - Souond functions
    
    private var sounds: AVAudioPlayer!
    private var tileDrop: AVAudioPlayer!
    private var backgroundURL: URL { soundFile(named: "background") }
    private var successURL: URL { soundFile(named: "match") }

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
    func playChime() {
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
        speakerIcon = playSounds ? "speaker.slash.fill" : "speaker.fill"

        if playSounds {
            playSound(backgroundURL, repeating: true)
        } else {
            sounds.stop()
        }
    }
    
    /// Creates the URL of a sound file. The file must exist within the minesweeper project
    /// bundle.
    private func soundFile(named file: String) -> URL {
        let bun = Bundle(for: MatchedPairsGameModel.self)
        let sound = bun.path(forResource: file, ofType: "mp3")
        return URL(fileURLWithPath: sound!)
    }

    /// Play a sound file. We will be passed the URL of the file in the current bundle. If sounds are
    /// disabled, we do nothing.
    private func playSound(_ url: URL, repeating: Bool = false) {
        guard playSounds else { return }
        if sounds != nil { sounds.stop() }
        
        sounds = try! AVAudioPlayer(contentsOf: url)
        sounds.numberOfLoops = repeating ? -1 : 0
        self.sounds.play()
    }
}
