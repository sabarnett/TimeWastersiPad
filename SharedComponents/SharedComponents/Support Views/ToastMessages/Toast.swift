//
// -----------------------------------------
// Original project: SharedComponents
// Original package: SharedComponents
// Created on: 16/08/2025 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2025 Steven Barnett. All rights reserved.
//

import SwiftUI

struct Toast: View {
    @Binding var toastMessage: ToastConfig?

    // Dark-ish grey colour.
    let toastColor: Color = Color(red: 153/255, green: 153/255, blue: 153/255)

    var body: some View {
        VStack {
            if let toast = toastMessage {
                HStack(spacing: 4) {
                    Image(systemName: toast.icon)
                    VStack(alignment: .leading, spacing: 0) {
                        if let title = toast.title {
                            Text(title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                        }

                        Text(toast.message)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .font(.system(size: 24))
                .foregroundStyle(toast.type.foregroundColor)

                // Padding round the internal content
                .padding(.vertical, 6)
                .padding(.leading, 8)
                .frame(width: 360)

                .background(RoundedRectangle(cornerRadius: 15).fill(toast.type.backgroundColor.gradient))

                // Padding above or below the message
                .padding(.vertical, 20)

                .transition(.move(edge: toast.alignment.edge))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + toast.showDuration) {
                        self.toastMessage = nil
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: toastMessage?.alignment.alignment ?? .top)
        .animation(.linear(duration: 0.25), value: toastMessage)
    }
}
