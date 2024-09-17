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

//struct EditableTipView: View {
//    let tipAmount: Decimal
//    let isEditing: Bool
//    let onEdit: () -> Void
//    let onEndEdit: (Decimal) -> Void
//
//    var body: some View {
//        if isEditing {
//            EditingTipView(tipAmount: tipAmount, onEndEdit: onEndEdit)
//        } else {
//            DisplayTipView(tipAmount: tipAmount, onEdit: onEdit)
//        }
//    }
//}
//
//struct DisplayTipView: View {
//    let tipAmount: Decimal
//    let onEdit: () -> Void
//
//    var body: some View {
//        HStack {
//            Text("Tip")
//            Spacer()
//            Text(tipAmount.formatted(.currency(code: "USD").precision(.fractionLength(2))))
//        }
//        .contentShape(Rectangle())
//        .onTapGesture(perform: onEdit)
//        .padding(.vertical, 8)
//    }
//}
//
//struct EditingTipView: View {
//    @State private var editedTipString: String
//    let tipAmount: Decimal
//    let onEndEdit: (Decimal) -> Void
//
//    init(tipAmount: Decimal, onEndEdit: @escaping (Decimal) -> Void) {
//        self.tipAmount = tipAmount
//        self.onEndEdit = onEndEdit
//        _editedTipString = State(initialValue: tipAmount.formatted(.number.precision(.fractionLength(2))))
//    }
//
//    var body: some View {
//        HStack {
//            Text("Tip")
//            Spacer()
//            TextField("Tip", text: $editedTipString)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//        }
//        .padding(.vertical, 8)
//        .onDisappear {
//            let updatedTip = Decimal(string: editedTipString) ?? tipAmount
//            onEndEdit(updatedTip)
//        }
//    }
//}

struct EditingTipView: View {
    @State private var editedTipString: String
    @Binding var isEditing: Bool
    let tipAmount: Decimal
    let onEndEdit: (Decimal) -> Void

    init(tipAmount: Decimal, isEditing: Binding<Bool>, onEndEdit: @escaping (Decimal) -> Void) {
        self.tipAmount = tipAmount
        self._isEditing = isEditing
        self.onEndEdit = onEndEdit
        _editedTipString = State(initialValue: tipAmount.formatted(.number.precision(.fractionLength(2))))
    }

    var body: some View {
        HStack {
            Text("Tip")
            Spacer()
            TextField("Tip", text: $editedTipString, onCommit: {
                updateAndDismiss()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.vertical, 8)
        .onDisappear {
            updateAndDismiss()
        }
    }
    
    private func updateAndDismiss() {
        let updatedTip = Decimal(string: editedTipString) ?? tipAmount
        onEndEdit(updatedTip)
        isEditing = false
    }
}

struct EditableTipView: View {
    let tipAmount: Decimal
    @Binding var isEditing: Bool
    let onEndEdit: (Decimal) -> Void

    var body: some View {
        if isEditing {
            EditingTipView(tipAmount: tipAmount, isEditing: $isEditing, onEndEdit: onEndEdit)
        } else {
            DisplayTipView(tipAmount: tipAmount) {
                isEditing = true
            }
        }
    }
}

struct DisplayTipView: View {
    let tipAmount: Decimal
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Text("Tip")
            Spacer()
            Text(tipAmount.formatted(.currency(code: "USD").precision(.fractionLength(2))))
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
        .padding(.vertical, 8)
    }
}

struct EditingTaxView: View {
    @State private var editedTaxString: String
    @Binding var isEditing: Bool
    let taxAmount: Decimal
    let onEndEdit: (Decimal) -> Void

    init(taxAmount: Decimal, isEditing: Binding<Bool>, onEndEdit: @escaping (Decimal) -> Void) {
        self.taxAmount = taxAmount
        self._isEditing = isEditing
        self.onEndEdit = onEndEdit
        _editedTaxString = State(initialValue: taxAmount.formatted(.number.precision(.fractionLength(2))))
    }

    var body: some View {
        HStack {
            Text("Tax")
            Spacer()
            TextField("Tax", text: $editedTaxString, onCommit: {
                updateAndDismiss()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.vertical, 8)
        .onDisappear {
            updateAndDismiss()
        }
    }
    
    private func updateAndDismiss() {
        let updatedTax = Decimal(string: editedTaxString) ?? taxAmount
        onEndEdit(updatedTax)
        isEditing = false
    }
}

struct EditableTaxView: View {
    let taxAmount: Decimal
    @Binding var isEditing: Bool
    let onEndEdit: (Decimal) -> Void

    var body: some View {
        if isEditing {
            EditingTaxView(taxAmount: taxAmount, isEditing: $isEditing, onEndEdit: onEndEdit)
        } else {
            DisplayTaxView(taxAmount: taxAmount) {
                isEditing = true
            }
        }
    }
}

struct DisplayTaxView: View {
    let taxAmount: Decimal
    let onEdit: () -> Void

    var body: some View {
        HStack {
            Text("Tax")
            Spacer()
            Text(taxAmount.formatted(.currency(code: "USD").precision(.fractionLength(2))))
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
        .padding(.vertical, 8)
    }
}

