//
//  BillDetailView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/29/24.
//

import Foundation
import SwiftUI

struct BillDetailView: View {
    @State private var menuItems = ["Chicken Tenders", "Bacon CheeseBurger"] 

    @StateObject var viewModel = BillViewModel()
    let billName: String
    
    struct Person: Identifiable {
        let id = UUID() // Unique identifier for each person
        let name: String
        // Add other properties here, such as duration and calories
    }

    // Then, your list of people would be an array of `Person` structs:
    let billPeople: [Person] = [
        Person(name: "Gary"),
        Person(name: "Nick"),
        Person(name: "Vince"),
        Person(name: "Mason")
        // Add more people as needed
    ]
    
    var body: some View {
            VStack {
                // Menu items view (top half of the screen)
                //MenuItemView()
                List(billPeople) { person in
                    Text(person.name).font(.headline)
                        .padding()
                    // Additional details here
                }
            }
            .navigationBarTitle("Chipotle", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                // Actions for your trailing navigation bar button
            }) {
                Text("Add")
            })
    }
}
    


// To define a preview provider for SwiftUI previews
struct BillDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap in a NavigationView for the preview
            BillDetailView(billName: "Example")
        }
    }
}

