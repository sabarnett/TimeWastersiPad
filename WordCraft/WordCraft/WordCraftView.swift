//
//  ContentView.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//

import SwiftUI
import SharedComponents

public struct WordCraftView: View {

    @AppStorage(Constants.wordcraftShowUsedWords) private var wordcraftShowUsedWords = true

    @State private var viewModel = WordCraftViewModel()
    @State private var gameData: Game

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        VStack {
            WordCraftToolBar(viewModel: viewModel)
                .confirmationDialog(
                    String("Reset the game?"),
                    isPresented: $viewModel.showResetConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Yes") { viewModel.reset() }
                    Button("No", role: .cancel) { }
                   } message: {
                       Text("This action cannot be undone. Would you like to proceed?")
                   }

               .confirmationDialog(
                   String("Reload saved game?"),
                   isPresented: $viewModel.showReloadConfirmation,
                   titleVisibility: .visible
               ) {
                   Button("Yes") { viewModel.restoreGame() }
                   Button("No", role: .cancel) { }
               } message: {
                   Text("You will lose any current progress if you do this.")
               }

            Spacer()
            VStack(alignment: .leading) {
                WordCraftRuleView(viewModel: viewModel)

                HStack(spacing: 5) {
                    GameBoardView(viewModel: viewModel)
                    if wordcraftShowUsedWords {
                        RecentWordsView(viewModel: viewModel)
                    }
                }
                .frame(height: 460)
            }

            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: {
                    viewModel.showGamePlay.toggle()
                }, label: {
                    Image(systemName: "questionmark.circle")
                })
                .help("Show game rules")
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.showResetConfirmation = true
                }, label: {
                    Image(systemName: "arrow.uturn.left.circle")
                })
                .help("Restart the game")

                Button(action: {
                    viewModel.saveGame()
                }, label: {
                    Image(systemName: "tray.and.arrow.down")
                })
                .help("Save the current game state.")

                Button(action: {
                    viewModel.showReloadConfirmation = true
                }, label: {
                    Image(systemName: "tray.and.arrow.up")
                })
                .help("Reload the last saved game.")

                Button(action: {
                    viewModel.toggleSounds()
                }, label: {
                    Image(systemName: viewModel.speakerIcon)
                })
                .help("Toggle sound effects")
            }
        }
        .padding()
        .onKeyPress(action: { keyPress in
            viewModel.selectLetter(keyPress)
            return .handled
        })
        .onAppear {
            viewModel.playBackgroundSound()
        }
        .sheet(isPresented: $viewModel.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .onDisappear {
            viewModel.stopSounds()
        }
        .toast(toastMessage: $viewModel.notifyMessage)
    }
}

#Preview {
    WordCraftView(gameData: Game.wordcraft)
}
