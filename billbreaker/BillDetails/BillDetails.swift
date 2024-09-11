//
//  NewBillDetails.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/2/24.
//

import Foundation
import SwiftUI

struct BillDetailsView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receiptId: String
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            List {
                Section(header: Text("Items")) {
                    ItemsSectionView(rviewModel: rviewModel)
                }
                PeopleSectionView(rviewModel: rviewModel)
                    .listRowSeparator(.hidden)
            }
        }
        .overlay(
            AddButton2(
                itemAction: { print("Add Item tapped") },
                personAction: { print("Add Person tapped") }
            )
            .padding(.trailing, 22)
            .padding(.bottom, -12)
        )
        .navigationBarTitle(rviewModel.receipt.name, displayMode: .automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareButtonView(rviewModel: rviewModel)
            }
        }
        .onAppear {
            rviewModel.setReceipt(receiptId: receiptId)
        }
    }

}


// Preview
//struct BillDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockItems = [
//            Item(id: "1", name: "Item 1", price: 10.0),
//            Item(id: "2", name: "Item 2", price: 15.0),
//            Item(id: "3", name: "Item 3", price: 20.0)
//        ]
//
//        let mockPeople = [
//            LegitP(id: "1", name: "John", claims: ["1", "2"], color: .green),
//            LegitP(id: "2", name: "Jane", claims: ["2", "3"], color: .blue),
//            LegitP(id: "3", name: "Joe", claims: ["3"], color: .orange)
//        ]
//
//        let mockReceipt = Receipt(id: "1", userId: "user1", name: "Test Receipt", date: "2024-05-28", createdAt: "12:00 PM", tax: 2.0, items: mockItems, people: mockPeople)
//
//        let mockViewModel = ReceiptViewModel()
//        mockViewModel.receipt = mockReceipt
//
//        return BillDetailsView(rviewModel: mockViewModel, receiptId: mockReceipt.id)
//            .environmentObject(UserViewModel())
//    }
//}
