//
//  SectionsForReview.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/29/24.
//

import Foundation
import SwiftUI

struct EditableItemView: View {
    let item: Item
    let isEditing: Bool
    let onEdit: () -> Void
    let onEndEdit: (Item) -> Void

    var body: some View {
        if isEditing {
            EditingItemView(item: item, onEndEdit: onEndEdit)
        } else {
            DisplayItemView(item: item, onEdit: onEdit)
        }
    }
}

struct DisplayItemView: View {
    let item: Item
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            Text(item.price.formatted(.currency(code: "USD").precision(.fractionLength(2))))
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
        .padding(.vertical, 8)
    }
}

struct EditingItemView: View {
    @State private var editedName: String
    @State private var editedPriceString: String
    let item: Item
    let onEndEdit: (Item) -> Void

    init(item: Item, onEndEdit: @escaping (Item) -> Void) {
        self.item = item
        self.onEndEdit = onEndEdit
        _editedName = State(initialValue: item.name)
        _editedPriceString = State(initialValue: item.price.formatted(.number.precision(.fractionLength(2))))
    }

    var body: some View {
        HStack {
            TextField("Name", text: $editedName)
            TextField("Price", text: $editedPriceString)
                .keyboardType(.decimalPad)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.vertical, 8)
        .onDisappear {
            let updatedPrice = Decimal(string: editedPriceString) ?? item.price
            let updatedItem = Item(id: item.id, name: editedName, price: updatedPrice)
            onEndEdit(updatedItem)
        }
    }
}

