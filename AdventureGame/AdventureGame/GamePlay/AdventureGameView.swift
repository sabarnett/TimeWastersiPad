//
// -----------------------------------------
// Original project: AdventureGame
// Original package: AdventureGame
// Created on: 25/10/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct AdventureGameView: View {

    @Environment(\.colorScheme) private var colorScheme

    @State public var gameData: Game
    @State var gameModel: GamePlayViewModel
    @State var columnsVisible: NavigationSplitViewVisibility = .all

    @FocusState private var inputFocus: Bool

    public init(gameData: SharedComponents.Game, game: String) {
        self.gameData = gameData
        gameModel = GamePlayViewModel(game: game)
    }

    public var body: some View {
        ZStack {
            VStack {
                NavigationSplitView(columnVisibility: $columnsVisible) {
                    ScrollView {
                        carriedItemsView
                        Divider().frame(height: 32)
                        treasureItemsView
                    }
                    .navigationBarHidden(true)
                    .padding(12)
                } detail: {
                    VStack {
                        gamePlayView
                            .padding(.bottom, 20)
                    }
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .environment(\.defaultMinListRowHeight, 10)
            .sheet(isPresented: $gameModel.showGamePlay) {
                GamePlayView(game: gameData.gameDefinition)
            }

            .alert("Reset Game?",
                   isPresented: $gameModel.showResetConfirmation
            ) {
                Button("Yes", role: .destructive) {
                    gameModel.restartGame()
                    inputFocus = true
                }
            } message: {
                Text("Are you sure you want to reset this game. All progress will be lost")
            }

            .alert("Reload Saved Game?",
                   isPresented: $gameModel.showReloadConfirmation) {
                Button("Yes", role: .destructive) {
                    gameModel.restoreGame()
                    inputFocus = true
                }
            } message: {
                Text("Are you sure you want to reload the saved game. The current game will be lost.")
            }

            .toolbar {
                topBarLeadingToolbar
                topBarTrailingToolbar
            }
            .onAppear {
                inputFocus = true
            }
            .toast(toastMessage: $gameModel.notifyMessage)

            if gameModel.gameOver {
                GameOverView(message: "Game Over!") {
                    withAnimation {
                        gameModel.restartGame()
                        inputFocus = true
                    }
                }
            }
        }
    }

    private var gamePlayView: some View {
        VStack(spacing: 0) {

            ScrollView {
                ForEach(gameModel.gameProgress) { gameProgress in
                    GameRowView(gameDataRow: gameProgress)
                }
            }
            .defaultScrollAnchor(.bottom)
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)

//            TextField("What do you want to do?",
//                      text: $gameModel.commandLine)
//            .font(.title)
//            .padding()
//            .background(colorScheme == .dark ? Color.black : Color.white)
//            .onSubmit {
//                gameModel.consoleEnter()
//            }
//            .disabled(gameModel.gameOver)
//            .focused($inputFocus)

            Keyboard(onEnter: { commandLine in
                print(commandLine)
                gameModel.commandLine = commandLine
                gameModel.consoleEnter()
            })
            .disabled(gameModel.gameOver)
        }
    }

    private var carriedItemsView: some View {
        Section(content: {
            ForEach(gameModel.carriedItems, id: \.self) { item in
                Text(item)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }, header: {
            HStack {
                Text("Inventory").font(.title)
                Spacer()
                Text("\(gameModel.carriedItemsCount) of \(gameModel.carriedItemsLimit)")
            }
            .listSectionSeparator(.hidden)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background {
                Color.accentColor.opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        })
        .listSectionSeparator(.hidden)
    }

    private var treasureItemsView: some View {
        Section(content: {
            ForEach(gameModel.treasureItems, id: \.self) { item in
                Text(item)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }, header: {
            HStack {
                Text("Treasures").font(.title)
                Spacer()
                Text("\(gameModel.treasuresFound) %")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .background {
                Color.accentColor.opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        })
        .listSectionSeparator(.hidden)
    }

    var topBarLeadingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button(action: {
                gameModel.showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle")
            })
        }
    }

    var topBarTrailingToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: {
                gameModel.showResetConfirmation = true
            }, label: {
                Image(systemName: "arrow.uturn.left.circle")
            })

            Button(action: {
                gameModel.saveGame()
            }, label: {
                Image(systemName: "tray.and.arrow.down")
            })

            Button(action: {
                gameModel.showReloadConfirmation = true
            }, label: {
                Image(systemName: "tray.and.arrow.up")
            })
        }
    }
}

#Preview {
    AdventureGameView(
        gameData: Game.adventure,
        game: "adv08")
}
