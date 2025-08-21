//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 28/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import Foundation

/*
 ADV01.DAT    Adventureland                                      v4.16
 ADV02.DAT    Pirate Adventure (a.k.a. Pirate's Cove)            v4.08
 ADV03.DAT    Secret Mission (orig. called Mission Impossible)   v3.06
 ADV04.DAT    Voodoo Castle                                      v1.19
 ADV05.DAT    The Count                                          v1.15
 ADV06.DAT    Strange Odyssey                                    v1.19
 ADV07.DAT    Mystery Fun House                                  v1.45
 ADV08.DAT    Pyramid of Doom                                    v1.25
 ADV09.DAT    Ghost Town                                         v2.23
 ADV10.DAT    Savage Island, Part I                              v1.23
 ADV11.DAT    Savage Island, Part II                             v1.33
 ADV12.DAT    The Golden Voyage
 */

@Observable
public class GameDefinitions {
    private var gamesList: GamesList!

    public var games: [GameDefinition] {
        gamesList.games
    }

    public func game(forKey key: String) -> GameDefinition? {
        return gamesList.games.first(where: { $0.file == key })
    }

    init() {
        let bundle = Bundle(for: GameDefinitions.self)
        let fileUrl = bundle.url(forResource: "GameIndex", withExtension: "json")

        if let jsFile = fileUrl {
            do {
                let jsonText = try String(contentsOf: jsFile, encoding: .utf8)
                let JSONData = jsonText.data(using: String.Encoding.utf8)

                let decoder = JSONDecoder()

                gamesList = try decoder.decode(GamesList.self, from: JSONData!)
                for game in games {
                    print(game.title)
                }
            } catch {
                print(error)
            }
        }
    }
}

/// The JSON file is just an array of game definition.
public class GamesList: Codable {
    public var games = [GameDefinition]()
}

/// There will be one entry foreach game. This defines the name adventure game,
/// the file that the game can be loaded from and the version of the game.
public class GameDefinition: Codable, CustomStringConvertible {
    public var description: String {
        return title
    }

    public var title: String = ""
    public var file: String = ""
    public var version: String = ""

    public static var dummy: GameDefinition {
        let dummy = GameDefinition()
        dummy.title = "Default Title"
        dummy.file = "defaultFile"
        dummy.version = "0.0.1"
        return dummy
    }
}
