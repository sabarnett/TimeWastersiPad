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
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var selectedGame: GameDefinition?
    
    @State private var showInfoFor: GameDefinition?
    @State private var showAbout = false
    @State private var showSettings = false
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                ForEach(Game.allCases, id: \.self) { game in
                    GameItemButtonView(game: game.gameDefinition, infoPressed: {
                        showInfoFor = game.gameDefinition
                    })
                    .padding(.bottom, 4)
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        selectedGame = game.gameDefinition
                    }
                }
            }
        }
        .sheet(item: $showInfoFor) { game in
            GameInfoView(gameData: game)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
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
