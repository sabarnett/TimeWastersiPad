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
    @Namespace var animation
    @Binding var selectedGame: Game?

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
                        GameItemButtonView(game: game)
                        .padding(.bottom, 16)
                        .onTapGesture {
                            selectedGame = game
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .navigationTransition(.zoom(sourceID: "settings", in: animation))
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
                .navigationTransition(.zoom(sourceID: "aboutBox", in: animation))
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showSettings.toggle()
                }, label: {
                    Image(systemName: "gearshape")
                })
                .matchedTransitionSource(id: "settings", in: animation)
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
            .matchedTransitionSource(id: "aboutBox", in: animation)
        }
    }
}

#Preview {
    GameMenuView(selectedGame: .constant(nil))
}
