//
//  ReviewView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/7/24.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    @ObservedObject var transformer: ReceiptProcessor
    @EnvironmentObject var router: Router
    @State private var editingItemId: String? = nil

    var body: some View {
        ZStack {
            FatCheckTheme.Colors.accentColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                List {
                    ForEach(transformer.receipt.items ?? [], id: \.id) { item in
                        EditableItemView(
                            item: item,
                            isEditing: editingItemId == item.id,
                            onEdit: { editingItemId = item.id },
                            onEndEdit: { updatedItem in
                                editingItemId = nil
                                updateItem(updatedItem)
                            }
                        )
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                .padding(FatCheckTheme.Spacing.sm)
            }
            .background(FatCheckTheme.Colors.accentColor)
            
            AddButton(action: {
                transformer.addItem(newItem: Item())
            })
            
        }
        .navigationBarItems(
            trailing: Button("Next") {
                router.navigateToItemsScanView(ScanRoute.people)
            }
        )
        .navigationBarTitle("Menu Items", displayMode: .inline)
        .accentColor(.blue)
    }

    private func deleteItems(at offsets: IndexSet) {
        transformer.receipt.items?.remove(atOffsets: offsets)
    }

    private func updateItem(_ updatedItem: Item) {
        if let index = transformer.receipt.items?.firstIndex(where: { $0.id == updatedItem.id }) {
            transformer.receipt.items?[index] = updatedItem
        }
    }
}


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
            Text(String(format: "%.2f", item.price))
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onEdit)
        .padding(.vertical, 8)
    }
}

struct EditingItemView: View {
    @State private var editedName: String
    @State private var editedPrice: Double
    let item: Item
    let onEndEdit: (Item) -> Void

    init(item: Item, onEndEdit: @escaping (Item) -> Void) {
        self.item = item
        self.onEndEdit = onEndEdit
        _editedName = State(initialValue: item.name)
        _editedPrice = State(initialValue: item.price)
    }

    var body: some View {
        HStack {
            TextField("Name", text: $editedName)
            TextField("Price", value: $editedPrice, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding(.vertical, 8)
        .onDisappear {
            let updatedItem = Item(id: item.id, name: editedName, price: editedPrice)
            onEndEdit(updatedItem)
        }
    }
}

