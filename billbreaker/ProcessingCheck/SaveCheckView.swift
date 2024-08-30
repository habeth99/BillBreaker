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
            
            List {
                Section(header: Text("Items")) {
                    ForEach(Array(transformer.receipt.items!.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.name)
                                .padding(.vertical, FatCheckTheme.Spacing.xs)
                            Spacer()
                            Text(item.price.formatted(.currency(code: "USD").precision(.fractionLength(2))))
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
                
                Section {
                    Button(action: cancel) {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(
                trailing: Button("Save", action: save)
            )
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

