//
//  BillViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation

class BillViewModel: ObservableObject {
    @Published var items: [BillItem] = []
    
    func addItem(name: String, price: Double) {
        let newItem = BillItem(name: name, price: price)
        items.append(newItem)
    }
    func totalPrice() -> Double {
        return items.reduce(0) { $0 + $1.price }
    }
}
