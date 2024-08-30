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
            VStack(spacing: 0) {
                List {
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
                    
                    Section {
                        Button(action: {
                            // navigates "back" to the camera
                            router.navToCamera()
                            //gets rid of items review page
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                router.endScanFlow()
                            }
                        }) {
                            Text("Re-scan")
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                    }
                    .padding(FatCheckTheme.Spacing.sm)
                    
                }
            }
            
            AddButton(action: {
                transformer.addItem(newItem: Item())
            })
            
        }
        .navigationBarItems(
            leading: Button("Cancel") {
                router.endScanFlow()
            },
            trailing: Button("Next") {
                router.navigateInScanFlow(to: .people)
            }
        )
        .navigationBarTitle("Items", displayMode: .inline)
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

