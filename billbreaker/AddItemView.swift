//
//  AddItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: BillViewModel
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    
    var body: some View {

            VStack {
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Price", text: $itemPrice)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Item") {
                    if let price = Double(itemPrice) {
                        viewModel.addItem(name: itemName, price: price)
                        itemName = ""
                        itemPrice = ""
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
            }

        
    }
}
