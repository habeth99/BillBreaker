//
//  NewBillDetails.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/2/24.
//

import Foundation
import SwiftUI

struct BillDetails2View: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receipt: Receipt
    
    var body: some View {
        ZStack {
            // Make background gray
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // MARK: Header
                    Text("Items")
                        .font(.title)
                        .fontWeight(.bold)
                    ItemsSectionView(rviewModel: rviewModel, receipt: receipt)
                    PeopleSectionView(rviewModel: rviewModel, receipt: receipt)
                }
                .padding(EdgeInsets(top: 30, leading: 19, bottom: 0, trailing: 24))
            }
        }
        .navigationBarTitle(receipt.name, displayMode: .automatic)
        .onAppear {
            rviewModel.setReceipt(receipt: receipt)
        }
    }
}

// Preview
struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockItems = [
            Item(id: "1", name: "Item 1", price: 10.0),
            Item(id: "2", name: "Item 2", price: 15.0),
            Item(id: "3", name: "Item 3", price: 20.0)
        ]

        let mockPeople = [
            LegitP(id: "1", name: "John", claims: ["1", "2"], color: .green),
            LegitP(id: "2", name: "Jane", claims: ["2", "3"], color: .blue),
            LegitP(id: "3", name: "Joe", claims: ["3"], color: .orange)
        ]

        let mockReceipt = Receipt(id: "1", userId: "user1", name: "Test Receipt", date: "2024-05-28", createdAt: "12:00 PM", tax: 2.0, price: 45.0, items: mockItems, people: mockPeople)

        let mockViewModel = ReceiptViewModel(user: UserViewModel())
        mockViewModel.receipt = mockReceipt

        return BillDetails2View(rviewModel: mockViewModel, receipt: mockReceipt)
            .environmentObject(UserViewModel())
    }
}
