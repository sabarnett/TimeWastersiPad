//
// -----------------------------------------
// Original project: TimeWasters
// Original package: TimeWasters
// Created on: 11/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SharedComponents
import SwiftUI

struct GameMenuView: View {
    @Binding var selectedGame: Game?

    @State private var showInfoFor: Game?
    @State private var showAbout = false
    @State private var showSettings = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Time Wasters")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.primary)

            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(Game.allCases, id: \.self) { game in
                        GameItemButtonView(game: game.gameDefinition, infoPressed: {
                            showInfoFor = game
                        })
                        .padding(.bottom, 4)
                        .onTapGesture {
                            selectedGame = game
                        }
                    }
                }
                .padding(.top, 16)
            }
            .padding(4)
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.gameMenuBackground)
            }
        }

        .sheet(item: $showInfoFor) { game in
            GameInfoView(gameData: game.gameDefinition)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
                .presentationDetents([.height(350)])
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showSettings.toggle()
                }, label: {
                    Image(systemName: "gearshape")
                })
            }

            ToolbarItem(placement: .bottomBar) {
                aboutBoxPopup()
            }
        }
    }

    fileprivate func aboutBoxPopup() -> some View {
        return HStack {
            Spacer()
            Button(action: { showAbout.toggle() },
                   label: {
                Image(systemName: "info.circle")
            })
        }
    }
}

#Preview {
    GameMenuView(selectedGame: .constant(nil))
}
