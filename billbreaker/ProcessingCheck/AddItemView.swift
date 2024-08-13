//
//  AddItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/13/24.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    @ObservedObject var transformer: ReceiptProcessor
    @Binding var isPresented: Bool
    @State private var itemName = ""
    @State private var itemPrice = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Item Name", text: $itemName)
                TextField("Price", text: $itemPrice)
                    .keyboardType(.decimalPad)
                
                Button("Add Item") {
                    if let price = Double(itemPrice) {
                        let newItem = Item(name: itemName, price: price)
                        transformer.addItem(newItem: newItem)
                        isPresented = false
                    }
                }
            }
            .navigationBarTitle("Add New Item", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
