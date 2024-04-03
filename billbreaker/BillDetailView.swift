//
//  BillDetailView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/29/24.
//

import Foundation
import SwiftUI

struct BillDetailView: View {
    @State private var menuItems = ["Chicken Tenders", "Bacon CheeseBurger"] // Corrected a typo in "CheeseBurger"
    @StateObject var viewModel = BillViewModel()
    let billName: String
    
    var body: some View {
        VStack {
            MenuItemView() // Assuming MenuItemView is another component you've defined
            Spacer()
            HorizontalScrollView() // Assuming HorizontalScrollView is another component you've defined
        }
        .navigationTitle(billName) // Sets the navigation title to the value of `billName`
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { // Adds an item to the navigation bar on the trailing side
                Button("Add") {
                    // Action to perform when the "Add" button is tapped
                    // For example, showing an AddItemView or updating the viewModel
                }
            }
        }
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

