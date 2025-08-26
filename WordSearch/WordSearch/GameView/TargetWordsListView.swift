//
// -----------------------------------------
// Original project: WordSearch
// Original package: WordSearch
// Created on: 05/03/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct TargetWordsListView: View {
    var game: WordSearchViewModel

    var body: some View {
        ScrollView {
            VStack {
                ForEach(game.words, id: \.id) { word in
                    TargetWord(word: word)
                        .onLongPressGesture(minimumDuration: 1.2) {
                            // Long press - do a hint
                            guard let letter = word.word.first else { return }
                            game.hilightLetter(letter: letter)
                        }
                }
            }
        }
        .frame(width: Constants.wordListWidth)
    }
}

struct TargetWord: View {
    @Environment(\.openURL) private var openURL

    var word: Word
    var dictionaryUrl: URL?

    init(word: Word) {
        self.word = word
        self.dictionaryUrl = URL(string: Constants.oed + word.word)
    }

    var body: some View {
        HStack {
            Text(word.word)
                .font(.system(size: 20))
                .padding(4)
                .padding(.leading, 4)
            Spacer()
            if dictionaryUrl != nil {
                Image(systemName: "link")
                    .onTapGesture {
                        openURL(dictionaryUrl!)
                    }
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .strokeBorder(Color.black, lineWidth: 0.8)
                .background(word.found ? Color.green.opacity(0.3) : Color.blue.opacity(0.3))
                .clipped()
        )
        .clipShape(Capsule())
    }
}
