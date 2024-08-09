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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Does this look right?")
                    .font(.largeTitle)
                Text(receipt.name)
                    .font(.title)
                    .padding()
                Text("Items")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                ForEach(receipt.items!) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.price, specifier: "%.2f")")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                }
                Text("Add guests")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                AddPeopleView()
            }
            .padding()
            Button(action: saveGuests) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 340)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .background(Color.gray.opacity(0.3))
    }
    
    private func saveGuests() {
        // Implement your save functionality here
        
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var mockReceipt: Receipt {
        let items = [
            Item(id: "1", name: "Cappuccino", quantity: 1, price: 3.99),
            Item(id: "2", name: "Almond Croissant", quantity: 1, price: 2.50),
            Item(id: "3", name: "Avocado Toast", quantity: 1, price: 7.99),
            Item(id: "4", name: "Fresh Orange Juice", quantity: 1, price: 4.50)
        ]
        
        return Receipt(
            id: "preview123",
            userId: "user123",
            name: "Cafe Receipt",
            date: "2024-08-07",
            createdAt: "2024-08-07T10:30:00Z",
            tax: 1.50,
            tip: 3.00,
            items: items,
            people: [],
            restaurantName: "Sunny Side Cafe",
            restaurantAddress: "123 Main St, Anytown, USA",
            dateTime: "2024-08-07T10:30:00Z",
            subTotal: 18.98,
            total: 23.48,
            paymentMethod: "Credit Card",
            cardLastFour: "1234"
        )

    }
    
    static var previews: some View {
        ReviewView(receipt: mockReceipt, transformer: ReceiptProcessor())
//            .previewLayout(.sizeThatFits)
//            .padding()
    }
}


