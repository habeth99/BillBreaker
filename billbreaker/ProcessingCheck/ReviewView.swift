//
//  ReviewView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/7/24.
//

import Foundation
import SwiftUI
import UIKit

struct ReviewView: View {
    @ObservedObject var transformer: ReceiptProcessor
    @EnvironmentObject var router: Router
    @State private var editingItemId: String? = nil
    @State private var tipAmountString: String = ""
    @State private var isEditingTip = false
    
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }
    
    
    
    var body: some View {
        ZStack {
            listContent
            addButton
        }
        .navigationBarItems(
            leading: cancelButton,
            trailing: nextButton
        )
        .navigationBarTitle("Items", displayMode: .inline)
        .accentColor(.blue)
    }
    
    private var listContent: some View {
        List {
            itemsSection
            tipSection
            rescanSection
        }
    }
    
    private var itemsSection: some View {
        Section {
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
    }
    
    private var tipSection: some View {
        Section(header: Text("Tip")) {
            EditableTipView(
                tipAmount: transformer.receipt.tip,
                isEditing: $isEditingTip,
                onEndEdit: { updatedTip in
                    isEditingTip = false
                    transformer.updateTip(updatedTip)
                }
            )
        }
    }
    
    private var rescanSection: some View {
        Section {
            Button(action: rescan) {
                Text("Re-scan")
                    .foregroundColor(.red)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
        }
        .padding(FatCheckTheme.Spacing.sm)
    }
    
    private var addButton: some View {
        AddButton(action: {
            transformer.addItem(newItem: Item())
        })
        .padding(.trailing, 22)
        .padding(.bottom, -12)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            router.endScanFlow()
        }
    }
    
    private var nextButton: some View {
        Button("Next") {
            router.navigateInScanFlow(to: .people)
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        transformer.receipt.items?.remove(atOffsets: offsets)
    }
    
    private func updateItem(_ updatedItem: Item) {
        if let index = transformer.receipt.items?.firstIndex(where: { $0.id == updatedItem.id }) {
            transformer.receipt.items?[index] = updatedItem
        }
    }
    
    private func rescan() {
        router.navToCamera()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            router.endScanFlow()
        }
    }
}

