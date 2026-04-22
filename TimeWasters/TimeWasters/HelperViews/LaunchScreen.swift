//
// -----------------------------------------
// Original project: TimeWasters
// Original package: TimeWasters
// Created on: 22/04/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                landscapeLayout(size: proxy.size)
            } else {
                // Portrait
                portraitLayout(size: proxy.size)
            }
        }
    }

    func landscapeLayout(size: CGSize) -> some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)

            Image(.gaming)
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center) {
                Text(Bundle.main.appName)
                    .font(.system(size: 120))
                    .padding(.top, 60)
                Text("Version \(Bundle.main.appVersionLong)")
                    .font(.system(size: 40))
                    .padding(.bottom, size.height / 5)
                Spacer()
                Text("\(Bundle.main.copyright)")
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .background(.black)
    }

    func portraitLayout(size: CGSize) -> some View {
        ZStack {
            Color(.black)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Image(.gamingPortrait)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .edgesIgnoringSafeArea(.all)

                Spacer()
            }
            .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center) {
                Text(Bundle.main.appName)
                    .font(.system(size: 120))
                    .padding(.top, 60)
                Text("Version \(Bundle.main.appVersionLong)")
                    .font(.system(size: 40))
                    .padding(.bottom, size.height / 5)

                Spacer()
                Text("\(Bundle.main.copyright)")
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    LaunchScreen()
}
