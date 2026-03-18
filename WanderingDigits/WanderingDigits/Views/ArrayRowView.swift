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

struct ArrayRowView: View {
    let arrayIndex: Int
    @Binding var arrays: [GameRow]

    let checkResult: (String, Int, Int, Int, Int) -> Bool

    @State private var dragOver: Int? = nil  // item index being hovered over

    var body: some View {
        HStack {
            ForEach(arrays[arrayIndex].values.indices, id: \.self) { itemIndex in
                Text(arrays[arrayIndex].values[itemIndex])
                    .font(.numberFont)
                    .monospacedDigit()
                    .background(dragOver == itemIndex
                                ? Color.blue.opacity(0.35)
                                : Color.clear)
                    .frame(alignment: .trailing)
                    .foregroundStyle(arrayIndex == 2 ? .secondary : .primary)

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

            // Append drop zone at the end of the row
            Color.clear
                .frame(maxWidth: 40)
                .frame(height: 30)
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

            // put the math operator at the end of the line. This is not eligible
            // for drag/drop activities
            Text(arrays[arrayIndex].mathOperator)
                .font(.operatorFont)
                .padding(.leading, 10)
                .frame(maxWidth: 80, alignment: .trailing)
        }
        .padding(.top, arrayIndex == 2 ? 28 : 0)
    }

    // MARK: - Drop Handler

    private func handleDrop(items: [DragItem], targetIndex: Int) -> Bool {
        guard
            let dragItem = items.first,
            dragItem.sourceArrayIndex != arrayIndex  // block same-array drops
        else {
            return false
        }

        let sourceArray = dragItem.sourceArrayIndex
        let sourceIndex = dragItem.sourceItemIndex
        let text = dragItem.text

        let accepted = checkResult(
            text,
            sourceArray, sourceIndex,
            arrayIndex, targetIndex
        )

        guard accepted else { return false }

        withAnimation {
            // Remove from source array
            arrays[sourceArray].values.remove(at: sourceIndex)

            // Recalculate insert index (target array is unaffected by source removal
            // since they are always different arrays)
            let insertIndex = min(targetIndex, arrays[arrayIndex].values.endIndex)
            arrays[arrayIndex].values.insert(text, at: insertIndex)
        }

        return true
    }
}
