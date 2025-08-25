//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LetterButtonView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var currentWord: String

    var letterBackground: Color {
        colorScheme == .dark ? .gray : .black
    }
    var letterForeground: Color {
        .white
    }

    var letter: String
    var keyboardModel: KeyboardModel

    var body: some View {
        Button {
            currentWord.append(letter.lowercased())
        } label: {
            Text(letter)
                .font(.system(size: keyboardModel.buttonFontSize))
                .frame(
                    width: keyboardModel.buttonWidth,
                    height: keyboardModel.buttonHeight
                )
                .background(letterBackground.gradient)
                .foregroundStyle(letterForeground)
        }
        .buttonStyle(.plain)
    }
}

struct LetterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LetterButtonView(currentWord: .constant("Word"),
                         letter: "L",
                         keyboardModel: KeyboardModel())
    }
}
