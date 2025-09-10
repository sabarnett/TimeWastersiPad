//
//  ContentView.swift
//  Wordcraft
//
//  Created by Paul Hudson on 24/08/2024.
//  Modified by Steve Barnett - 2025
//

import SwiftUI
import SharedComponents

public struct WordCraftView: View {
    @Environment(\.colorScheme) private var colorScheme

    @State private var viewModel = WordCraftViewModel()
    @State private var gameData: Game
    @State var columnsVisible: NavigationSplitViewVisibility = .all
    @FocusState private var isFocused: Bool

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        NavigationSplitView(columnVisibility: $columnsVisible) {
            List {
                RecentWordsView(viewModel: viewModel)
            }
            .navigationBarHidden(true)
        } detail: {
            VStack {
                WordCraftToolBar(viewModel: viewModel)
                WordCraftRuleView(viewModel: viewModel)
                    .padding(.bottom, 20)

                GeometryReader { proxy in
                    let boardWidth = proxy.size.width
                    let cellWidth = boardWidth / CGFloat(viewModel.columns.count + 1)

                    HStack {
                        Spacer()
                        GameBoardView(viewModel: viewModel,
                                      cellWidth: cellWidth)
                        Spacer()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button(action: { viewModel.showGamePlay.toggle() },
                       label: { Image(systemName: "questionmark.circle") })
                .help("Show game rules")
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                Button(action: { viewModel.showResetConfirmation = true },
                       label: { Image(systemName: "arrow.uturn.left.circle") })
                .help("Restart the game")

                Button(action: { viewModel.saveGame() },
                       label: { Image(systemName: "tray.and.arrow.down") })
                .help("Save the current game state.")

                Button(action: { viewModel.showReloadConfirmation = true },
                       label: { Image(systemName: "tray.and.arrow.up") })
                .help("Reload the last saved game.")

                Button(action: { viewModel.toggleSounds() },
                       label: { Image(systemName: viewModel.speakerIcon) })
                .help("Toggle sound effects")
            }
        }

        // Handle the keyboard when on the Mac. We have to make the
        // view focusable and focussed or we will not get the
        // keyPress event.
        .focusable()
        .focused($isFocused)
        .onKeyPress(action: { keyPress in
            viewModel.selectLetter(keyPress)
            return .handled
        })
        .onAppear {
            viewModel.playBackgroundSound()
            isFocused = true
        }
        .sheet(isPresented: $viewModel.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .alert("Reset Game?", isPresented: $viewModel.showResetConfirmation) {
            Button("Yes", role: .destructive) { viewModel.reset() }
        } message: {
            Text("Are you sure you want to reset the current game. All progress will be lost.")
        }
        .alert("Reload Saved Game?", isPresented: $viewModel.showReloadConfirmation) {
            Button("Yes", role: .destructive) { viewModel.restoreGame() }
        } message: {
            Text("Are you sure you want to reload the saved gave? Any current progress will be lost.")
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
