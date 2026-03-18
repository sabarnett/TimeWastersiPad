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

struct ArrayColumnView: View {
    let arrayIndex: Int
    @Binding var arrays: [GameRow]

    let checkResult: (String, Int, Int, Int, Int) -> Bool

    @State private var dragOver: Int? = nil  // item index being hovered over

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ForEach(arrays[arrayIndex].values.indices, id: \.self) { itemIndex in
                Text(arrays[arrayIndex].values[itemIndex])
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(dragOver == itemIndex
                                ? Color.blue.opacity(0.35)
                                : Color.blue.opacity(0.15))
                    .cornerRadius(8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    // Drag source
                    .draggable(DragItem(
                        text: arrays[arrayIndex].values[itemIndex],
                        sourceArrayIndex: arrayIndex,
                        sourceItemIndex: itemIndex
                    ))
                    // Drop target — insert before this item
                    .dropDestination(for: DragItem.self) { items, _ in
                        handleDrop(items: items, targetIndex: itemIndex)
                    } isTargeted: { isOver in
                        dragOver = isOver ? itemIndex : nil
                    }
            }

            // Append drop zone at the bottom of the column
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            dragOver == arrays[arrayIndex].values.endIndex
                                ? Color.blue : Color.clear,
                            lineWidth: 2
                        )
                )
                .dropDestination(for: DragItem.self) { items, _ in
                    handleDrop(items: items, targetIndex: arrays[arrayIndex].values.endIndex)
                } isTargeted: { isOver in
                    dragOver = isOver ? arrays[arrayIndex].values.endIndex : nil
                }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }

    // MARK: - Drop Handler

    private func handleDrop(items: [DragItem], targetIndex: Int) -> Bool {
        print("Handle drop")
        guard
            let dragItem = items.first,
            dragItem.sourceArrayIndex != arrayIndex  // block same-array drops
        else {
            return false
        }

        let sourceArray = dragItem.sourceArrayIndex
        let sourceIndex = dragItem.sourceItemIndex
        let text = dragItem.text

        print("Dragged item text \(text)")
        let accepted = checkResult(
            text,
            sourceArray, sourceIndex,
            arrayIndex, targetIndex
        )

        print("Value accepted")
        guard accepted else { return false }

        print("Remove item at index \(sourceIndex)")
        // Remove from source array
        arrays[sourceArray].values.remove(at: sourceIndex)

        // Recalculate insert index (target array is unaffected by source removal
        // since they are always different arrays)
        let insertIndex = min(targetIndex, arrays[arrayIndex].values.endIndex)
        print("Insert at index \(insertIndex)")
        arrays[arrayIndex].values.insert(text, at: insertIndex)

        print(arrays)
        return true
    }
}
