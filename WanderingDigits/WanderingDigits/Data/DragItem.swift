//
// -----------------------------------------
// Original project: WanderingDigits
// Original package: WanderingDigits
// Created on: 18/03/2026 by: Steven Barnett
// Web: http://www.sabarnett.co.uk
// GitHub: https://www.github.com/sabarnett
// -----------------------------------------
// Copyright © 2026 Steven Barnett. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragItem: Transferable, Codable {
    let text: String
    let sourceArrayIndex: Int
    let sourceItemIndex: Int

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .dragItem)
    }
}
