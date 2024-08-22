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
    
    var height = CGFloat(270)
    
    init(receipt: Receipt){
        self.receipt = receipt
    }
    
    var body: some View {
        Button(action: navTo) {
            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md)
                .fill(FatCheckTheme.Colors.white)
                .frame(width: 370, height: height)
                .overlay(
                    VStack (alignment: .leading) {
                        VStack(alignment: .leading){
                            Text(receipt.name)
                                .font(.title)
                                //.padding(FatCheckTheme.Spacing.sm)
                            Text(receipt.formatDate(), style: .date)
                                .font(.subheadline)
                        }
                        HStack{
                            CardDetails(total: receipt.getTotal())
                            Spacer()
                            CheckProgressCirc(
                                fullAmount: receipt.getTotal(),
                                amountPaid: receipt.calculateAmountPaid(),
                                stillOwed: receipt.calculateStillOwed()
                            )
                        }
                        VStack (alignment: .leading) {
                            Text("Not paid up:")
                            HStack {
                                ForEach(receipt.people ?? []) { person in
                                    PersonPill(person: person, amountOwed: receipt.amountOwedByPerson(person.id))
                                }
                            }
                        }
                    }
                    .padding(FatCheckTheme.Spacing.md)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func navTo() {
        router.navigateToReceipt(id: receipt.id)
    }
}

// Mock data
let mockReceipt = Receipt(
    id: "1",
    name: "Dinner at Luigi's",
    date: "2024-07-15",
    tax: 2.00,
    tip: 6.00,
    items: [
        Item(id: "1", name: "Pizza", price: 10.00),
        Item(id: "2", name: "Veal", price: 10.00),
        Item(id: "3", name: "Chicken Parm", price: 10.00),
        Item(id: "4", name: "White Wine", price: 10.00),
        Item(id: "5", name: "Pizza2", price: 10.00),
        Item(id: "6", name: "Red Wine", price: 10.00)
    ],
    people: [
        LegitP(id: "1", name: "Alice", claims: ["1","2"], paid: false),
        LegitP(id: "2", name: "Bob", claims: ["3","4"],paid: false),
        LegitP(id: "3", name: "Charlie", paid: false),
        LegitP(id: "4", name: "David", paid: true)
    ]
)

// Preview
struct CheckCard_Previews: PreviewProvider {
    static var previews: some View {
        CheckCard(receipt: mockReceipt)
            //.previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray)
    }
}
