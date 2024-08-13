//
//  AddItemBox.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/12/24.
//

import Foundation
import SwiftUI

struct AddItemBox: View {
    @State private var name: String = ""
    @State private var price: String = ""
    @State private var qty: String = ""
    @Binding var isPresented: Bool
    @ObservedObject var transformer: ReceiptProcessor
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md, style: .continuous)
                .frame(width: 350, height: 350, alignment: .bottom)
                .foregroundColor(FatCheckTheme.Colors.white)
            
            VStack(spacing: FatCheckTheme.Spacing.sm) {
                HStack {
                    Button(action: {
                        //todo
                        isPresented = false
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(FatCheckTheme.Colors.accentColor)
                            .font(.title2)
                    })
                    Spacer()
                }
                
                Text("New Item")
                    .padding(FatCheckTheme.Spacing.md)
                
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .frame(maxWidth: 200, maxHeight: 300, alignment: .center)
                
                TextField("Price", text: $price)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 200, maxHeight: 300, alignment: .center)
                
                TextField("Quantity", text: $qty)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: 200, maxHeight: 300, alignment: .center)

                Spacer()
                
                Button(action: saavitem) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(FatCheckTheme.Spacing.xxl)
                        .frame(maxWidth: 200, maxHeight: 35)
                        .background(FatCheckTheme.Colors.primaryColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                Spacer()
            }
            .frame(width: 320, height: 290)
        }
    }
    
    private func saavitem() {
        // Convert price to Double
        let priceValue = Double(price) ?? 0.0
        
        // Convert quantity to Int
        let qtyValue = Int(qty) ?? 0
        
        // Create new item
        let newItem = Item(id: "",
                           name: name,
                           quantity: qtyValue,
                           price: priceValue)
        
        // Add the new item to the transformer
        transformer.addItem(newItem: newItem)
        
        print("Saved item: \(newItem)")
        
        // Clear the input fields
        name = ""
        price = ""
        qty = ""
        
        // Dismiss the view
        isPresented = false
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(FatCheckTheme.Spacing.xxs)
            .background(
                RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs)
                    .fill(Color.white.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            )
    }
}

//#Preview {
//    AddItemBox()
//}
