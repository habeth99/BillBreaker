//
//  MenuItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/2/24.
//

import Foundation
import SwiftUI

struct MenuItemView: View {
    let billItems: [BillItem] = [
        BillItem(name: "Chicken Tenders", price: 5.99),
        BillItem(name: "Bacon Cheeseburger", price: 7.99),
        BillItem(name: "Veggie Pizza", price: 8.99)
        // Add more items as needed
    ]
    
    var body: some View {
        List(billItems) { item in
            HStack {
                Text(item.name)
                Spacer()
                Text(String(format: "$%.2f", item.price))
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView()
    }
}

