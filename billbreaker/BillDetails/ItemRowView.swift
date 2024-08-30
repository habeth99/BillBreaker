//
//  ItemRowView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

//struct ItemRowView: View {
//    var item: Item
//    var users: [LegitP]
//    @ObservedObject var rviewModel: ReceiptViewModel
//    
//    var body: some View {
//        VStack{
//            HStack {
//                Text(item.name)
//                    .padding()
//                ForEach(users ?? [], id: \.id) { person in
//
//                    if (!users.isEmpty) {
//                        Circle()
//                            .fill(person.color)
//                            .frame(width: 19, height: 19)
//                            .padding(.vertical)
//                            .overlay(
//                                Text(person.name.prefix(1)) // Display only the first letter to fit the circle
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                            )
//                    }
//                }
//                Spacer()
////                Text(String(format: "$%.2f", item.price))
//                Text("$\(NSDecimalNumber(decimal: item.price).stringValue)")
//                    .padding()
//            }
//            .onTapGesture {
//                if rviewModel.selectedPerson != nil {
//                    rviewModel.toggleItemSelection(item)
//                } else {
//                    print("No person selected")
//                }
//            }
//        }
//    }
//}
struct ItemRowView: View {
    var item: Item
    var users: [LegitP]
    @ObservedObject var rviewModel: ReceiptViewModel
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    private var formattedPrice: String {
        return currencyFormatter.string(from: NSDecimalNumber(decimal: item.price)) ?? "$0.00"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                    .padding(.vertical, FatCheckTheme.Spacing.xs)
                ForEach(users ?? [], id: \.id) { person in
                    if (!users.isEmpty) {
                        Circle()
                            .fill(person.color)
                            .frame(width: 19, height: 19)
                            //.padding(.vertical, FatCheckTheme.Spacing.sm)
                            .overlay(
                                Text(person.name.prefix(1)) // Display only the first letter to fit the circle
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                }
                Spacer()
                Text(formattedPrice)
                    .padding(.vertical, FatCheckTheme.Spacing.xs)
            }
            .onTapGesture {
                if rviewModel.selectedPerson != nil {
                    rviewModel.toggleItemSelection(item)
                } else {
                    print("No person selected")
                }
            }
        }
    }
}
