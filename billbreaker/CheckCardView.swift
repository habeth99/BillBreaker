//
//  CheckCardView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/14/24.
//

import Foundation
import SwiftUI

struct CheckCard: View {
    var receipt: Receipt
    @EnvironmentObject var router: Router
    
    private var progressValue: Double {
        let amountPaid = receipt.getTotal() - receipt.amtOwed()
        return (amountPaid as NSDecimalNumber).doubleValue / (receipt.getTotal() as NSDecimalNumber).doubleValue
    }
    
    init(receipt: Receipt){
        self.receipt = receipt
    }
    
    var body: some View {
        Button(action: navTo) {
            VStack (alignment: .leading, spacing: 0) {
                HStack(alignment:.top) {
                    Text(receipt.name)
                        .font(.title)
                    Spacer()
                    Text(receipt.formatDate(), style: .date)
                        .font(.subheadline)
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                HStack{
                    CardDetails(total: receipt.amtOwed(), title: "Amount owed")
                    Spacer()
                    CardDetails(total: receipt.getTotal(), title: "Total")
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                
                VStack {
                    ProgressView(value: progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: FatCheckTheme.Colors.primaryColor))
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                
                VStack (alignment: .leading) {
                    Text("Not paid up")
                        .font(.subheadline)
                    ForEach(receipt.people ?? []) { person in
                        NameTag(person: person, amountOwed: receipt.amountOwedByPerson(person.id), receipt: receipt)
                    }
                }
            }
            .padding(FatCheckTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.sm)
                    .fill(FatCheckTheme.Colors.white)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func navTo() {
        router.navigateToReceipt(id: receipt.id)
    }
}

// Mock data
//let mockReceipt = Receipt(
//    id: "1",
//    name: "Dinner at Luigi's",
//    date: "2024-07-15",
//    tax: 2.00,
//    tip: 6.00,
//    items: [
//        Item(id: "1", name: "Pizza", price: 10.00),
//        Item(id: "2", name: "Veal", price: 10.00),
//        Item(id: "3", name: "Chicken Parm", price: 10.00),
//        Item(id: "4", name: "White Wine", price: 10.00),
//        Item(id: "5", name: "Pizza2", price: 10.00),
//        Item(id: "6", name: "Red Wine", price: 10.00)
//    ],
//    people: [
//        LegitP(id: "1", name: "Alice", claims: ["1","2"], paid: false),
//        LegitP(id: "2", name: "Bob", claims: ["3","4"], paid: false),
//        LegitP(id: "3", name: "Charlie", claims: ["5","6"], paid: true)
//    ]
//)
//
//// Preview
//struct CheckCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckCard(receipt: mockReceipt)
//            //.previewLayout(.sizeThatFits)
//            .padding()
//            .background(Color.gray)
//    }
//}
