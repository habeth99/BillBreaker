//
//  NewReceiptSheet.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/8/24.
//

import Foundation
import SwiftUI

struct NewReceiptView: View {
    @Binding var isPresented: Bool // Use this to dismiss the sheet
    @State private var name = ""
    @State private var itemsText = ""
    @State private var peopleText = ""
    @State private var taxText = ""
    @State private var totalText = ""
    @State private var people: [LegitP] = [LegitP()]
    @State private var items: [Item] = [Item()] // Initialize with one empty item
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        NavigationView {
            List {
                restaurantNameSection
                numberOfItemsSection
                itemDetailsSection
                numberOfPeopleSection
                peopleDetailsSection
                taxAndTotalSection
            }
            .navigationTitle("New Receipt")
            .navigationBarItems(leading: cancelButton, trailing: nextButton)
            .onChange(of: itemsText) { newValue in
                updateItemsBasedOnText(newValue)
            }
            .onChange(of: peopleText) { newValue in
                updatePeopleBasedOnText(newValue)
            }
        }
    }
    
    private func updateItemsBasedOnText(_ newValue: String) {
        if let count = Int(newValue), count >= 0 {
            items = (0..<count).map { _ in Item(id: "", name: "", price: 0.0) }
        } else {
            items = [Item(id: "", name: "", price: 0.0)]
        }
    }

    private func updatePeopleBasedOnText(_ newValue: String) {
        if let count = Int(newValue), count >= 0 {
            people = (0..<count).map { _ in LegitP(id: "", name: "") }
        } else {
            people = [LegitP(id: "", name: "")]
        }
    }

    private var restaurantNameSection: some View {
        Section {
            TextField("Enter restaurant name", text: $name)
        }
    }

    private var numberOfItemsSection: some View {
        Section(header: Text("Enter number of items")) {
            TextField("Number of items", text: $itemsText)
                .keyboardType(.numberPad)
        }
    }

    private var itemDetailsSection: some View {
        Section(header: Text("Item Details")) {
            ForEach(0..<items.count, id: \.self) { index in
                HStack {
                    TextField("Item \(index + 1)", text: Binding(
                        get: { items[index].name },
                        set: { items[index].name = $0 }
                    ))
                    .frame(maxWidth: .infinity)
                    
                    TextField("Price", text: Binding(
                        get: { String(format: "%.2f", items[index].price) },
                        set: { items[index].price = Double($0) ?? 0.0 }
                    ))
                    .keyboardType(.decimalPad)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }

    private var numberOfPeopleSection: some View {
        Section(header: Text("Enter number of people")) {
            TextField("Number of people", text: $peopleText)
                .keyboardType(.numberPad)
        }
    }

    private var peopleDetailsSection: some View {
        Section(header: Text("People Details")) {
            ForEach(0..<people.count, id: \.self) { index in
                TextField("Person \(index + 1)", text: Binding(
                    get: { people[index].name },
                    set: { people[index].name = $0 }
                ))
            }
        }
    }

    private var taxAndTotalSection: some View {
        Section {
            TextField("Enter tax", text: $taxText)
            TextField("Enter total price", text: $totalText)
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }

    private var nextButton: some View {
        Button(action: {
            guard let total = Double(totalText), let tax = Double(taxText) else {
                print("Invalid input for total price or tax.")
                return
            }
            print("Total Price: \(total), Tax: \(tax)")
            
            print("Items before calling newReceipt: \(items)")
            
            rviewModel.newReceipt(name: name, tax: tax, price: total, items: items, people: people)
            
            rviewModel.setItems()
            rviewModel.setPeople()
            
            rviewModel.saveReceipt() { success in
                if success {
                    print("Receipt saved successfully.")
                    isPresented = false
                } else {
                    print("Failed to save the receipt.")
                }
            }
        })
        {
            Text("Next")
        }
    }

    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}




