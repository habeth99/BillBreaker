//
//  MenuItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/2/24.
//

import Foundation
import SwiftUI

struct MenuItemView: View {
    @State private var selectedItems: [String] = []
    let billItems: [BillItem] = [
        BillItem(name: "Chicken Tenders", price: 5.99),
        BillItem(name: "Bacon Cheeseburger", price: 7.99),
        BillItem(name: "Veggie Pizza", price: 8.99),
        BillItem(name: "Milkshake", price: 5.99),
        BillItem(name: "Seed Oil Salad", price: 7.99),
        BillItem(name: "Keener Teener Tenner", price: 8.99)
        // Add more items as needed
    ]
    var totalPrice: Double {
        billItems.filter { selectedItems.contains($0.name) }
                  .reduce(0) { $0 + $1.price }
    }
    
    var body: some View {
        //VStack {
            List(billItems) { item in
                HStack {
                    Text(item.name)
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                }
                .onTapGesture {
                    if selectedItems.contains(item.name) {
                        selectedItems.removeAll(where: { $0 == item.name }) // Deselect
                    } else {
                        selectedItems.append(item.name) // Select
                    }
                }
                .listRowBackground(selectedItems.contains(item.name) ? Color.blue : Color.clear) // Apply background to the entire row
                
            }
            //.background(Color.gray)
            //Text("Total Price: $\(totalPrice, specifier: "%.2f")")
        //}
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}


