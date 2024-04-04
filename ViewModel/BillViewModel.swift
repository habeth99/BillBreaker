//
//  BillViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation

class BillViewModel: ObservableObject {
    
    //OG objects
    @Published var items: [BillItem] = []
    @Published var tipPercentage: Int = 15
    //New wave objects
    @Published var newBill: Bill = Bill()
    
    @Published var bills: [Bill] = []
    
    func addBill(_ bill: Bill) {
        bills.append(bill)
    }
    
    func removeBill(at index: IndexSet) {
        bills.remove(atOffsets: index)
    }
    ///________________________________________
    ///
    ///
    ///________________________________________
    
    
    func addParticipant(name: String) {
        // Manually notify observers that a change will occur
        self.objectWillChange.send()
        
        // Modify the struct, which is actually creating and assigning a modified copy
        var updatedBill = newBill
        updatedBill.participants.append(name)
        newBill = updatedBill // Assign the modified copy back to the original property
    }
    
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
