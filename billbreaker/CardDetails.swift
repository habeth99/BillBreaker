//
//  CardDetails.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/22/24.
//

import Foundation
import SwiftUI

struct CardDetails: View {
    var total: Decimal
    var title: String
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: total)) ?? "$0.00"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(formattedTotal)
                .font(.largeTitle)
                .fontWeight(.medium)
            Text(title)
                .font(.subheadline)
        }
    }
}

//let mockCheck = Receipt(
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
//        LegitP(id: "2", name: "Bob", claims: ["3","4"],paid: false),
//        LegitP(id: "3", name: "Charlie", paid: false),
//        LegitP(id: "4", name: "David", paid: true)
//    ]
//)
//
//// Preview
//struct CardDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        CardDetails(receipt: mockCheck)
//    }
//}

