//
//  NewReceiptSheet.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/8/24.
//

import Foundation
import SwiftUI

//struct NewReceiptView: View {
//    @Binding var isPresented: Bool
//    @State private var name = ""
//    @State private var itemsText = ""
//    @State private var peopleText = ""
//    @State private var tipText = ""
//    @State private var taxText = ""
//    @State private var totalText = ""
//    @State private var people: [LegitP] = [LegitP()]
//    @State private var items: [Item] = [Item()]
//    @ObservedObject var rviewModel: ReceiptViewModel
//    
//    private let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .pink, .gray]
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                restaurantNameSection
//                numberOfItemsSection
//                itemDetailsSection
//                numberOfPeopleSection
//                peopleDetailsSection
//                taxTipAndTotalSection
//            }
//            .navigationTitle("New Receipt")
//            .navigationBarItems(leading: cancelButton, trailing: nextButton)
//            .onChange(of: itemsText) { newValue in
//                updateItemsBasedOnText(newValue)
//            }
//            .onChange(of: peopleText) { newValue in
//                updatePeopleBasedOnText(newValue)
//            }
//        }
//    }
//    
//    private func updateItemsBasedOnText(_ newValue: String) {
//        if let count = Int(newValue), count >= 0 {
//            items = (0..<count).map { _ in Item(id: "", name: "", price: 0.0) }
//        } else {
//            items = [Item(id: "", name: "", price: 0.0)]
//        }
//    }
//
//    private func updatePeopleBasedOnText(_ newValue: String) {
//        if let count = Int(newValue), count >= 0 {
//            people = (0..<count).map { i in LegitP(id: "", name: "", color: colors[i]) }
//        } else {
//            people = [LegitP(id: "", name: "", color: .blue)]
//        }
//    }
//
//    private var restaurantNameSection: some View {
//        Section {
//            TextField("Enter restaurant name", text: $name)
//        }
//    }
//
//    private var numberOfItemsSection: some View {
//        Section(header: Text("Enter number of items")) {
//            TextField("Number of items", text: $itemsText)
//                .keyboardType(.numberPad)
//        }
//    }
//
//    private var itemDetailsSection: some View {
//        Section(header: Text("Item Details")) {
//            ForEach(0..<items.count, id: \.self) { index in
//                HStack {
//                    TextField("Item \(index + 1)", text: Binding(
//                        get: { items[index].name },
//                        set: { items[index].name = $0 }
//                    ))
//                    .frame(maxWidth: .infinity)
//                    
//                    TextField("Price", text: Binding(
//                        get: { String(format: "%.2f", items[index].price) },
//                        set: { items[index].price = Decimal($0) ?? 0.0 }
//                    ))
//                    .keyboardType(.decimalPad)
//                }
//            }
//            .onDelete(perform: deleteItems)
//        }
//    }
//
//    private var numberOfPeopleSection: some View {
//        Section(header: Text("Enter number of people")) {
//            TextField("Number of people", text: $peopleText)
//                .keyboardType(.numberPad)
//        }
//    }
//
//    private var peopleDetailsSection: some View {
//        Section(header: Text("People Details")) {
//            ForEach(0..<people.count, id: \.self) { index in
//                TextField("Person \(index + 1)", text: Binding(
//                    get: { people[index].name },
//                    set: { people[index].name = $0 }
//                ))
//            }
//        }
//    }
//
//    private var taxTipAndTotalSection: some View {
//        Section {
//            TextField("Enter tax", text: $taxText)
//            TextField("Enter total price", text: $totalText)
//            TextField("Enter tip", text: $tipText)
//        }
//    }
//
//    private var cancelButton: some View {
//        Button("Cancel") {
//            isPresented = false
//        }
//    }
//
//    private var nextButton: some View {
//        Button(action: {
//            guard let total = Decimal(totalText), let tax = Decimal(taxText) else {
//                print("Invalid input for total price or tax.")
//                return
//            }
//            print("Total Price: \(total), Tax: \(tax)")
//            
//            print("Items before calling newReceipt: \(items)")
//            
//            guard let tip = Decimal(tipText) else{
//                print("Invalid input for tip")
//                return
//            }
//            
//            rviewModel.newReceipt(name: name, tax: tax, tip: tip, price: total, items: items, people: people)
//            
//            rviewModel.setItems()
//            rviewModel.setPeople()
//            
//            rviewModel.saveReceipt() { success in
//                if success {
//                    print("Receipt saved successfully.")
//                    isPresented = false
//                } else {
//                    print("Failed to save the receipt.")
//                }
//            }
//        })
//        {
//            Text("Next")
//        }
//    }
//
//    func deleteItems(at offsets: IndexSet) {
//        items.remove(atOffsets: offsets)
//    }
//}
struct NewReceiptView: View {
    @Binding var isPresented: Bool
    @State private var name = ""
    @State private var itemsText = ""
    @State private var peopleText = ""
    @State private var tipText = ""
    @State private var taxText = ""
    @State private var totalText = ""
    @State private var people: [LegitP] = [LegitP()]
    @State private var items: [Item] = [Item()]
    @ObservedObject var rviewModel: ReceiptViewModel

    private let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .pink, .gray]

    var body: some View {
        NavigationStack {
            List {
                restaurantNameSection
                numberOfItemsSection
                itemDetailsSection
                numberOfPeopleSection
                peopleDetailsSection
                taxTipAndTotalSection
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
            items = (0..<count).map { _ in Item(id: "", name: "", price: Decimal.zero) }
        } else {
            items = [Item(id: "", name: "", price: Decimal.zero)]
        }
    }

    private func updatePeopleBasedOnText(_ newValue: String) {
        if let count = Int(newValue), count >= 0 {
            people = (0..<count).map { i in LegitP(id: "", name: "", color: colors[i % colors.count]) }
        } else {
            people = [LegitP(id: "", name: "", color: .blue)]
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

                    TextField("Price", value: Binding(
                        get: { items[index].price },
                        set: { items[index].price = $0 }
                    ), formatter: NumberFormatter.currencyFormatter)
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

    private var taxTipAndTotalSection: some View {
        Section {
            TextField("Enter tax", value: $taxText, formatter: NumberFormatter.currencyFormatter)
            TextField("Enter total price", value: $totalText, formatter: NumberFormatter.currencyFormatter)
            TextField("Enter tip", value: $tipText, formatter: NumberFormatter.currencyFormatter)
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }

    private var nextButton: some View {
        Button(action: {
            guard let total = Decimal(string: totalText),
                  let tax = Decimal(string: taxText),
                  let tip = Decimal(string: tipText) else {
                print("Invalid input for total price, tax, or tip.")
                return
            }
            
            print("Total Price: \(total), Tax: \(tax), Tip: \(tip)")
            print("Items before calling newReceipt: \(items)")

            rviewModel.newReceipt(name: name, tax: tax, tip: tip, price: total, items: items, people: people)

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
        }) {
            Text("Next")
        }
    }

    func deleteItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}

extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}




