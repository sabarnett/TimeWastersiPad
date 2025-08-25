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

struct Keyboard: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var currentCommand: String = ""
    @State private var keyboardModel: KeyboardModel = KeyboardModel()

    var onEnter: (String) -> Void

    private var topRowArray = "QWERTYUIOP".map { String($0).lowercased() }
    private var secondRowArray = "ASDFGHJKL".map { String($0).lowercased() }
    private var thirdRowArray = "ZXCVBNM".map { String($0).lowercased() }

    init(onEnter: @escaping (String) -> Void) {
        self.onEnter = onEnter
    }

    var body: some View {
        VStack {
            HStack {
                Text(currentCommand)
                    .font(.system(size: keyboardModel.textFontSize))
                Spacer()
                Button {
                    onEnter(currentCommand)
                    currentCommand = ""
                } label: {
                    Image(systemName: "return")
                        .bold()
                        .frame(minHeight: keyboardModel.buttonHeight)
                }
            }.padding()

            HStack(spacing: keyboardModel.buttonSpacing) {
                ForEach(topRowArray, id: \.self) { letter in
                    LetterButtonView(
                        currentWord: $currentCommand,
                        letter: letter,
                        keyboardModel: keyboardModel
                    )
                }
            }

            HStack(spacing: keyboardModel.buttonSpacing) {
                ForEach(secondRowArray, id: \.self) { letter in
                    LetterButtonView(
                        currentWord: $currentCommand,
                        letter: letter,
                        keyboardModel: keyboardModel
                    )
                }
            }

            HStack(spacing: keyboardModel.buttonSpacing) {
                Button {
                    onEnter(currentCommand)
                    currentCommand = ""
                } label: {
                    Text("Enter")
                }
                .font(.system(size: keyboardModel.buttonFontSize))
                .frame(
                    width: keyboardModel.buttonWidth * 2.0,
                    height: keyboardModel.buttonHeight
                )
                .foregroundColor(.white)
                .background(Color.gray.gradient)
                ForEach(thirdRowArray, id: \.self) { letter in
                    LetterButtonView(
                        currentWord: $currentCommand,
                        letter: letter,
                        keyboardModel: keyboardModel
                    )
                }
                Button {
                    currentCommand.removeLast()
                } label: {
                    Image(systemName: "delete.backward.fill")
                        .font(.system(size: keyboardModel.buttonFontSize, weight: .heavy))
                        .frame(width: keyboardModel.buttonWidth * 2, height: keyboardModel.buttonHeight)
                        .foregroundColor(.white)
                        .background(.gray.gradient)
                }
            }

            HStack(spacing: keyboardModel.buttonSpacing) {
                Button {
                    currentCommand.append(" ")
                } label: {
                    let spaceBarWidth: CGFloat = keyboardModel.buttonWidth *
                        CGFloat(thirdRowArray.count + 4) +
                        keyboardModel.buttonSpacing * 8.0
                    Text("Space")
                        .font(.system(size: keyboardModel.buttonFontSize))
                        .frame(
                            width: spaceBarWidth,
                            height: keyboardModel.buttonHeight
                        )
                        .contentShape(Rectangle())
                }
                .foregroundColor(.white)
                .background(Color.gray.gradient)
            }
        }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard(onEnter: { commandLine in
            print(commandLine)
        })
    }
}
