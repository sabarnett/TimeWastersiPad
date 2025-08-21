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

    @FocusState private var inputFocus: Bool

    public init(gameData: SharedComponents.Game, game: String) {
        self.gameData = gameData
        gameModel = GamePlayViewModel(game: game)
    }

    public var body: some View {
        ZStack {
            VStack {
                NavigationSplitView {
                    List {
                        carriedItemsView
                        Spacer().frame(height: 32)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)
                        treasureItemsView
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)
                    }
                } detail: {
                    VStack {
                        topBarAndButtons
                            .padding(.horizontal, 8)

                        gamePlayView
                    }
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .sheet(isPresented: $gameModel.showGamePlay) {
                GamePlayView(game: gameData.gameDefinition)
            }
            .onAppear {
                inputFocus = true
            }
            .toast(toastMessage: $gameModel.notifyMessage)

            .confirmationDialog(
                String("Reset the game?"),
                isPresented: $gameModel.showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Yes") {
                    gameModel.restartGame()
                    inputFocus = true
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("This action cannot be undone. Would you like to proceed?")
            }
            .confirmationDialog(
                String("Reload saved game?"),
                isPresented: $gameModel.showReloadConfirmation,
                titleVisibility: .visible
            ) {
                Button("Yes") {
                    gameModel.restoreGame()
                    inputFocus = true
                }
                Button("No", role: .cancel) { }
            } message: {
                Text("You will lose any current progress is you do this.")
            }

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

    private var topBarAndButtons: some View {
        HStack {
            Button(action: {
                gameModel.showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Show game rules")

            Spacer()

            Button(action: {
                gameModel.showResetConfirmation = true
            }, label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Restart the game.")

            Button(action: {
                gameModel.saveGame()
            }, label: {
                Image(systemName: "tray.and.arrow.down.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Save the current game state.")

            Button(action: {
                gameModel.showReloadConfirmation = true
            }, label: {
                Image(systemName: "tray.and.arrow.up.fill")
                    .padding(.vertical, 5)
            })
            .buttonStyle(.plain)
            .help("Reload the last saved game.")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
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

            TextField("What do you want to do?",
                      text: $gameModel.commandLine)
            .font(.title)
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
            .onSubmit {
                gameModel.consoleEnter()
            }
            .disabled(gameModel.gameOver)
            .focused($inputFocus)
        }
    }

    private var carriedItemsView: some View {
        Section(content: {
            ForEach(gameModel.carriedItems, id: \.self) { item in
                Text(item)
                    .font(.system(size: 14))
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
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
            .padding(.horizontal, 10)
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
                    .font(.system(size: 14))
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
            }
        }, header: {
            HStack {
                Text("Treasures").font(.title)
                Spacer()
                Text("\(gameModel.treasuresFound) %")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                Color.accentColor.opacity(0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        })
        .listSectionSeparator(.hidden)
    }
}

#Preview {
    AdventureGameView(
        gameData: Game.adventure,
        game: "adv08")
}
