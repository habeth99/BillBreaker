//
//  ClaimItemsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import SwiftUI

struct ClaimItemsView: View {
    // State variables for showing the sheet and knowing
    // if a person is selected
    //@State private var isSheetPresented = false
    //@State private var selectedPerson: Person?
    
    let billItems: [BillItem] = [
        BillItem(name: "Chicken Burrito", price: 8.99),
        BillItem(name: "Steak Bowl", price: 9.99),
        BillItem(name: "Chicken Bowl", price: 8.99),
        BillItem(name: "Barbacoa Bowl", price: 7.99),
        BillItem(name: "Lemonade", price: 2.99),
        BillItem(name: "Lemonade", price: 2.99),
        BillItem(name: "Chips", price: 3.99),
        BillItem(name: "Guacamole", price: 4.99)
        // ... more items
    ]
//    struct Person: Identifiable, Hashable {
//        let id = UUID() // Unique identifier for each person
//        let name: String
//        // Add other properties here, such as duration and calories
//    }
//    let billPeople: [Person] = [
//        Person(name: "Gary"),
//        Person(name: "Nick"),
//        Person(name: "Vince"),
//        Person(name: "Mason")
//        // Add more people as needed
//    ]
    
    // should be this
    let person: Person
    @Binding var anotherValue: String
    
    var body: some View {
        VStack {
            Text("Claim \(person.name)'s items")
                .fontWeight(.bold)
                .font(.largeTitle)
                .padding()
            Text(anotherValue)
            Spacer()
        }
    }
}




