//
//  ItemsSectionView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct EditingItemView2: View {
    @ObservedObject var item: Item
    let onEndEdit: (Item) -> Void
    @State private var editedName: String
    @State private var editedPriceString: String

    init(item: Item, onEndEdit: @escaping (Item) -> Void) {
        self._item = ObservedObject(wrappedValue: item)
        self.onEndEdit = onEndEdit
        self._editedName = State(initialValue: item.name)
        self._editedPriceString = State(initialValue: item.price.formatted(.number.precision(.fractionLength(2))))
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
            item.name = editedName
            if let updatedPrice = Decimal(string: editedPriceString) {
                item.price = updatedPrice
            }
            onEndEdit(item)
        }
    }
}

struct ItemsSectionView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @State private var editingItemId: String?
    
    var body: some View {
        ForEach(rviewModel.receipt.items ?? [], id: \.id) { item in
            let users = self.getUsersForItem(item: item)
            
            ZStack {
                if editingItemId == item.id {
                    EditingItemView2(item: item, onEndEdit: { updatedItem in
                        if let index = rviewModel.receipt.items?.firstIndex(where: { $0.id == updatedItem.id }) {
                            rviewModel.receipt.items?[index] = updatedItem
                        }
                        editingItemId = nil
                    })
                } else {
                    ItemRowView2(item: item, users: users, rviewModel: rviewModel)
                        .padding(.vertical, FatCheckTheme.Spacing.md)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editingItemId = item.id
                        }
                        .overlay(
                            GeometryReader { geometry in
                                HStack {
                                    Spacer()
                                        .frame(width: geometry.size.width * 0.5)
                                    Rectangle()
                                        .fill(Color.clear)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            if rviewModel.selectedPerson != nil {
                                                rviewModel.toggleItemSelection(item)
                                            }
                                        }
                                }
                            }
                        )
                }
            }
            .swipeActions {
                Button(role: .destructive) {
                    deleteItem(item)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .onChange(of: editingItemId) { _ in
            rviewModel.objectWillChange.send()
        }
    }
    
    private func getUsersForItem(item: Item) -> [LegitP] {
        return rviewModel.receipt.people?.filter { $0.claims.contains { $0 == item.id } } ?? []
    }
    
    private func deleteItem(_ item: Item) {
        rviewModel.receipt.deleteItem(id: item.id)
        rviewModel.saveReceipt { success in
            if success {
                print("Receipt saved successfully")
            } else {
                print("Failed to save receipt")
            }
        }
    }
}

struct ItemRowView2: View {
    var item: Item
    var users: [LegitP]
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 8) {
                Text(item.name)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(users, id: \.id) { person in
                        Circle()
                            .fill(person.color)
                            .frame(width: 19, height: 19)
                            .overlay(
                                Text(person.name.prefix(1))
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                
                Text(item.price.formatted(.currency(code: "USD")))
                    .frame(width: 70, alignment: .trailing)
            }
        }
    }
}

