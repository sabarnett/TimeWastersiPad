//
// -----------------------------------------
// Original project: NumberCombinations
// Original package: NumberCombinations
// Created on: 19/11/2024 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2024 Steven Barnett. All rights reserved.
//

import SwiftUI
import SharedComponents

public struct CombinationsView: View {

    @AppStorage(Constants.ncDisplayInterimResult) private var displayInterimResult: Bool = false

    @State public var gameData: Game
    @State var model = CombinationsViewModel()

    public init(gameData: Game) {
        self.gameData = gameData
    }

    public var body: some View {
        ZStack {
            VStack {
                topBarAndButtons
                    .padding(.horizontal, 8)
                Spacer()

                HStack {
                    VStack {
                        HStack {
                            DisplayNumber(model.values[0])
                            DisplayNumber(model.values[1])
                        }
                        HStack {
                            DisplayNumber(model.values[2])
                            DisplayNumber(model.values[3])
                        }
                    }
                    Text("=")
                        .font(.system(size: 48, weight: .bold))
                    DisplayNumber(model.result, asResult: true)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("Enter your formula", text: $model.formula)
                            .font(.title2)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        if displayInterimResult {
                            Text(" = \(model.interimResult)")
                                .font(.title2)
                        }
                    }
                    Text(model.formulaErrors)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                Spacer()
            }.disabled(model.success)

            if model.success {
                GameOverView(message: "You got it!!") {
                    withAnimation {
                        model.generatePuzzle()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            model.generatePuzzle()
            model.playBackgroundSound()
        }
        .sheet(isPresented: $model.showGamePlay) {
            GamePlayView(game: gameData.gameDefinition)
        }
        .sheet(isPresented: $model.showLeaderBoard) {
            LeaderBoardView(leaderBoard: model.leaderBoard)
        }
        .toast(toastMessage: $model.notifyMessage)
    }

    var topBarAndButtons: some View {
        HStack {
            Button(action: {
                model.showGamePlay.toggle()
            }, label: {
                Image(systemName: "questionmark.circle.fill")
            })
            .buttonStyle(.plain)
            .help("Show game rules")

            Button(action: {
                model.showLeaderBoard.toggle()
            }, label: {
                Image(systemName: "trophy.circle.fill")
            })
            .buttonStyle(.plain)
            .help("Show the leader board")

            Spacer()

            Button(action: {
                model.generatePuzzle()
            }, label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
            })
            .buttonStyle(.plain)
            .help("Restart the game")

            Button(action: {
                model.showSolution()
            }, label: {
                Image(systemName: "squareshape.split.2x2")
            })
            .buttonStyle(.plain)
            .help("Show/Hide the solution")

            Button(action: {
                model.toggleSounds()
            }, label: {
                Image(systemName: model.speakerIcon)
            })
            .buttonStyle(.plain)
            .help("Toggle sound effects")
        }
        .monospacedDigit()
        .font(.largeTitle)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    CombinationsView(gameData: Game.numberCombinations)
}
