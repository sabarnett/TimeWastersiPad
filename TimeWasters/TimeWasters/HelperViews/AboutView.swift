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

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(uiImage: Bundle.main.icon ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .frame(width: 100, height: 100, alignment: .center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(Bundle.main.appName)")
                        .font(.system(size: 20, weight: .bold))
                        .textSelection(.enabled)
                    
                    Text("Ver: \(Bundle.main.appVersionLong) (\(Bundle.main.appBuild)) ")
                        .textSelection(.enabled)
                }
                .foregroundStyle(.primary)
            }
            .padding([.leading, .top, .trailing], 12)
            
            VStack(alignment: .leading, spacing: 8) {
                LabeledContent("Appliation support from") {
                    Link(Constants.homeAddress,
                         destination: Constants.homeUrl )
                }
                
                LabeledContent("Sound files from") {
                    Link("zapsplat.com",
                         destination: URL(string: "https://www.zapsplat.com")!)
                }
                
                LabeledContent("Home page images supplied by") {
                    Link("pixabay.com",
                         destination: URL(string: "https://pixabay.com")!)
                }
                
                LabeledContent("Some game ideas from Paul Hudson") {
                    Link("Hacking With Swift+",
                         destination: URL(string: "https://www.hackingwithswift.com/plus")!)
                }
            }
            .padding([.leading, .trailing], 20)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(Bundle.main.copyright)
                    .font(.system(size: 12, weight: .thin))
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.trailing, 12)
            }
        }
    }
}

#Preview {
    AboutView()
}
