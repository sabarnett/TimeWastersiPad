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
    @Bindable var board: GameBoard

    let checkResult: (String, Int, Int, Int, Int) -> Bool

    @State private var dragOver: Int? = nil  // item index being hovered over

    var body: some View {
        HStack {
            let row = board.row(at: arrayIndex)

            ForEach(row.indices, id: \.self) { itemIndex in
                let number = row.value(at: itemIndex)
                if number == "-" {
                    // A sign value cannot be dragged and dropped
                    Text(row.value(at: itemIndex))
                        .font(.numberFont)
                        .background(dragOver == itemIndex
                                    ? Color.blue.opacity(0.35)
                                    : Color.clear)
                        .frame(alignment: .trailing)
                        .foregroundStyle(arrayIndex == 2 ? .secondary : .primary)
                } else {
                    // display the number and setup for drag and drop
                    Text(row.value(at: itemIndex))
                        .font(.numberFont)
                        .padding(.horizontal)
                        .background(dragOver == itemIndex
                                    ? Color.blue.opacity(0.35).gradient
                                    : Color.green.opacity(0.6).gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 25))

                        .frame(alignment: .trailing)
                        .foregroundStyle(arrayIndex == 2 ? .secondary : .primary)

                        // Drag source
                        .draggable(DragItem(
                            text: row.value(at: itemIndex),
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
            }

            // Append drop zone at the end of the row
            Color.clear
                .frame(maxWidth: 40)
                .frame(height: 30)
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            dragOver == row.endIndex
                                ? Color.blue : Color.clear,
                            lineWidth: 2
                        )
                )
                .dropDestination(for: DragItem.self) { items, _ in
                    handleDrop(items: items, targetIndex: row.endIndex)
                } isTargeted: { isOver in
                    dragOver = isOver ? row.endIndex : nil
                }

            // put the math operator at the end of the line. This is not eligible
            // for drag/drop activities
            Text(board.row(at: arrayIndex).mathOperator)
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
            board.row(at: sourceArray).values.remove(at: sourceIndex)

            // Recalculate insert index (target array is unaffected by source removal
            // since they are always different arrays)
            let insertIndex = min(targetIndex, board.row(at: arrayIndex).endIndex)
            board.row(at: arrayIndex).values.insert(text, at: insertIndex)
        }

        return true
    }
}
