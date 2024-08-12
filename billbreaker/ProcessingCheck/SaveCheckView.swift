//
//  SaveCheckView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/11/24.
//

import Foundation
import SwiftUI

struct SaveCheckView: View {
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    var transformer: ReceiptProcessor
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            FatCheckTheme.Colors.accentColor
                .ignoresSafeArea()
            VStack {
                topButtons
                ScrollView {
                    VStack(spacing: 10) {
                        // ForEach to show items
                        Text("Items")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(Array(transformer.receipt.items!.enumerated()), id: \.offset) { index, item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text("$\(item.price, specifier: "%.2f")")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                        
                        Text("Dinner Guests")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ForEach(Array(transformer.receipt.people!.enumerated()), id: \.offset) { index, person in
//                            HStack {
//                                Text(item.name)
//                                Spacer()
//                                Text("$\(item.price, specifier: "%.2f")")
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(8)
                            Text(person.name)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
                Spacer()
                // Button to save
                saveButton
                // Button to cancel
                cancelButton
            }
            .padding(.horizontal)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Save Receipt"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .overlay(
            Group {
                if isSaving {
                    ProgressView("Saving...")
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }
        )
    }
    
    private var topButtons: some View {
        HStack {
            Button(action: onDismiss) {
                Text("Back")
                    .foregroundColor(.black)
            }
            Spacer()
            Text(transformer.receipt.name)
            Spacer()
            Button(action: save) {
                Text("Save")
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical)
    }
    
    private var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(10)
        }
    }
    
    private var saveButton: some View {
        Button(action: save) {
            Text("Save")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(10)
        }
        .disabled(isSaving)
    }
    
    private func cancel() {
        isPresented = false
    }
    
    private func save() {
        //todo
        isSaving = true
        transformer.saveReceipt2 { success in
            DispatchQueue.main.async {
                isSaving = false
                if success {
                    alertMessage = "Receipt saved successfully!"
                    showAlert = true
                    isPresented = false
                } else {
                    alertMessage = "Failed to save receipt. Please try again."
                    showAlert = true
                }
            }
        }
    }
}

// Mock data
//extension ReceiptProcessor {
//    static var mockProcessor: ReceiptProcessor {
//        let mockItems = [
//            Item(name: "Pizza", price: 12.99),
//            Item(name: "Salad", price: 7.99),
//            Item(name: "Soda", price: 2.50),
//            Item(name: "Dessert", price: 5.99)
//        ]
//        let mockReceipt = Receipt(items: mockItems)
//        return ReceiptProcessor()
//    }
//}
//
//struct SaveCheckView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveCheckView(
//            isPresented: .constant(true),
//            onDismiss: {},
//            transformer: ReceiptProcessor.mockProcessor
//        )
//    }
//}
