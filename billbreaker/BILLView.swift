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
                .navigationBarItems(leading: NavigationLink("Add Item", destination: AddItemView(viewModel: viewModel)))
                
                

                HStack {
                    Button(action: {viewModel.decrementTip()}) {
                        Image(systemName: "minus.circle.fill")
                            .font(.largeTitle)
                    }
                    .padding()
                    
                    Text("Tip: \(viewModel.tipPercentage)%")
                        .padding()
                    
                    Button(action: {viewModel.incrementTip()}) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                    }
                    .padding()
                }

                Text("Total Price: \(viewModel.totalPrice(), specifier: "$%.2f")")
                Text("Total with Tip: \(viewModel.totalWithTip(), specifier: "$%.2f")")
                HorizontalScrollView()
                    .frame(height: 150)
            }
    }
}

#Preview {
    BILLView()
}
