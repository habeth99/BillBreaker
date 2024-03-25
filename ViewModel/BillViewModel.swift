//
//  BillViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation

class BillViewModel: ObservableObject {
    @Published var items: [BillItem] = []
    @Published var tipPercentage: Int = 15
    
    func addItem(name: String, price: Double) {
        let newItem = BillItem(name: name, price: price)
        items.append(newItem)
    }
    
    func totalPrice() -> Double {
        return items.reduce(0) { $0 + $1.price }
    }
    
    // Calculate the total price including the tip
    func totalWithTip() -> Double {
        let total = totalPrice()
        let tipValue = total * (Double(tipPercentage) / 100.0)
        return total + tipValue
    }

    // Increment the tip percentage
    func incrementTip() {
        tipPercentage += 5
    }

    // Decrement the tip percentage
    func decrementTip() {
        tipPercentage = max(tipPercentage - 5, 0) // Prevents the tip from going negative
    }


}
