//
//  SaveCheckView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/11/24.
//

import Foundation
import SwiftUI

struct SaveCheckView: View {
    @EnvironmentObject var router: Router
    var transformer: ReceiptProcessor
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack {
                List {
                    Section(header: Text("Items")) {
                        ForEach(Array(transformer.receipt.items!.enumerated()), id: \.offset) { index, item in
                            HStack {
                                Text(item.name)
                                    .padding(.vertical, FatCheckTheme.Spacing.xs)
                                Spacer()
                                Text("$\(NSDecimalNumber(decimal: item.price).stringValue)")
                                    .padding(.vertical, FatCheckTheme.Spacing.xs)
                            }
                        }
                    }
                    Section(header: Text("Friends")) {
                        if (transformer.receipt.people?.count ?? 0) > 1 {
                            ForEach(transformer.receipt.people!, id: \.id) { person in
                                Text(person.name)
                                    .padding(.vertical, FatCheckTheme.Spacing.xs)
                            }
                        } else {
                            Text("Warning: No friends added, please add friends")
                                .foregroundColor(.red)
                                .padding(.vertical, FatCheckTheme.Spacing.xs)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
                saveButton
                    .padding(.horizontal, FatCheckTheme.Spacing.sm)
                cancelButton
                    .padding(.horizontal, FatCheckTheme.Spacing.sm)
            }
        }
        .navigationBarTitle("Review", displayMode: .inline)
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
        router.endScanFlow()
    }
    
    private func save() {
        isSaving = true
        transformer.saveReceipt2 { success in
            DispatchQueue.main.async {
                isSaving = false
                if success {
                    alertMessage = "Receipt saved successfully!"
                    showAlert = true
                    router.endScanFlow()
                    router.navigateToReceipt(id: transformer.receipt.id)
                    
                } else {
                    alertMessage = "Failed to save receipt. Please try again."
                    showAlert = true
                }
            }
        }
    }
}

//Preview
struct SaveCheckView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SaveCheckView(transformer: MockReceiptProcessor())
                .environmentObject(Router())
        }
    }
}

// Mock data and classes
class MockReceiptProcessor: ReceiptProcessor {
    var mockReceipt: Receipt = Receipt(
        items: [
            Item(name: "Burger", price: 12.99),
            Item(name: "Fries", price: 3.99),
            Item(name: "Soda", price: 2.49),
            Item(name: "Ice Cream", price: 5.99)
        ],
        people: [
            LegitP(name: "Alice"),
            LegitP(name: "Bob"),
            LegitP(name: "Charlie")
        ]
    )
}

