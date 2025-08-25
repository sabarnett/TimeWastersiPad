//
// -----------------------------------------
// Original project: MatchedPairs
// Original package: MatchedPairs
// Created on: 11/02/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct ScrollViewCarouselView: View {
    @Binding var scrollID: Int?

    let myBundle = Bundle(for: MatchedPairsGameModel.self)

    var cardImages: [CardBackgrounds] {
        CardBackgrounds.allCases
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(cardImages, id: \.id) { card in
                    VStack {
                        Image(card.cardImage, bundle: myBundle)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .padding()
                        Text(card.cardTitle)
                            .font(.title2)
                    }
                    .containerRelativeFrame(.horizontal)
                    .scrollTransition(.animated, axis: .horizontal) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.6)
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollID)
        .scrollTargetBehavior(.paging)
    }
}

#Preview {
    ScrollViewCarouselView(scrollID: .constant(1))
}
