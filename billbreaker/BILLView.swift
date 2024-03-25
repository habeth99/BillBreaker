//
//  EnterItemsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI

struct BILLView: View {
    @StateObject var viewModel = BillViewModel()
    
    var body: some View {
        
            VStack {
                List(viewModel.items) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(String(format: "$%.2f", item.price))
                    }
                }
                .navigationTitle("Bill Items")
            .navigationBarItems(trailing: NavigationLink("Add Item", destination: AddItemView(viewModel: viewModel)))
                Text("Total Price: \(viewModel.totalPrice(), specifier: "$%.2f")")
            }
    }
}

#Preview {
    BILLView()
}
