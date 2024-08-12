//
//  ReviewView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/7/24.
//

import Foundation
import SwiftUI

struct ReviewView: View {
    var receipt: Receipt
    @ObservedObject var transformer: ReceiptProcessor
    @State private var showingAddPeopleView = false
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(receipt.name)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                    Text("Items")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                    ForEach(Array(receipt.items!.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price, specifier: "%.2f")")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                            Button(action: addItem) {
                                Text("Add Item")
                                    .frame(maxWidth: .infinity)
                                    .font(.headline)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(FatCheckTheme.Colors.primaryColor)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
            }
            .background(FatCheckTheme.Colors.accentColor)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Next") {
                    showingAddPeopleView = true
                }
            )
            .navigationBarTitle("Review Your Check", displayMode: .inline)
            .accentColor(FatCheckTheme.Colors.secondaryColor)
        }
        .sheet(isPresented: $showingAddPeopleView) {
            AddPeopleView(isPresented: $isPresented, onDismiss: { showingAddPeopleView = false }, transformer: transformer)
        }
    }
    
    private func addItem() {
        //TODO
    }
}

//struct ReviewView_Previews: PreviewProvider {
//    static var mockReceipt: Receipt {
//        let items = [
//            Item(id: "1", name: "Cappuccino", quantity: 1, price: 3.99),
//            Item(id: "2", name: "Almond Croissant", quantity: 1, price: 2.50),
//            Item(id: "3", name: "Avocado Toast", quantity: 1, price: 7.99),
//            Item(id: "4", name: "Fresh Orange Juice", quantity: 1, price: 4.50)
//        ]
//        
//        return Receipt(
//            id: "preview123",
//            userId: "user123",
//            name: "Cafe Receipt",
//            date: "2024-08-07",
//            createdAt: "2024-08-07T10:30:00Z",
//            tax: 1.50,
//            tip: 3.00,
//            items: items,
//            people: [],
//            restaurantName: "Sunny Side Cafe",
//            restaurantAddress: "123 Main St, Anytown, USA",
//            dateTime: "2024-08-07T10:30:00Z",
//            subTotal: 18.98,
//            total: 23.48,
//            paymentMethod: "Credit Card",
//            cardLastFour: "1234"
//        )
//
//    }
//    
//    static var previews: some View {
//        ReviewView(receipt: mockReceipt, transformer: ReceiptProcessor())
//    }
//}


