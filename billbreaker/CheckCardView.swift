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
    
    private let width: CGFloat = 370
    private let height: CGFloat = 200
    
    init(receipt: Receipt){
        self.receipt = receipt
    }
    
    var body: some View {
        Button(action: navTo) {
            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.md)
                .fill(FatCheckTheme.Colors.white)
                .frame(width: width, height: height)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        Text(receipt.name)
                            .font(.headline)
                            .foregroundColor(FatCheckTheme.Colors.primaryColor)
                        
                        Text(receipt.formatDate(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(FatCheckTheme.Colors.primaryColor.opacity(0.8))
                        
                        CustomProgressView(
                            value: Float(receipt.countClaimedItems()),
                            total: Float(receipt.items?.count ?? 0),
                            fillColor: FatCheckTheme.Colors.primaryColor,
                            backgroundColor: .black.opacity(0.3),
                            label: "Items Claimed"
                        )
                        
                        CustomProgressView(
                            value: Float(receipt.countPaidFrnds()),
                            total: Float(receipt.people?.count ?? 0),
                            fillColor: FatCheckTheme.Colors.primaryColor,
                            backgroundColor: .black.opacity(0.3),
                            label: "Members Paid"
                        )
                        
                        MemberInitialsView(friends: receipt.people ?? [])
                    }
                    .padding(FatCheckTheme.Spacing.sm)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func navTo() {
        router.navigateToReceipt(id: receipt.id)
    }
}

struct MemberInitialsView: View {
    let friends: [LegitP]
    private let circleSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(friends, id: \.id) { friend in
                Circle()
                    .fill(FatCheckTheme.Colors.white)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .strokeBorder(FatCheckTheme.Colors.primaryColor, lineWidth: 2)
                    )
                    .overlay(
                        Text(friend.getFirstInitial())
                            .foregroundColor(FatCheckTheme.Colors.primaryColor)
                            .font(.system(size: 14, weight: .bold))
                    )
            }
        }
    }
}

struct CustomProgressView: View {
    var value: Float
    var total: Float
    var fillColor: Color
    var backgroundColor: Color
    var label: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(FatCheckTheme.Colors.primaryColor)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(backgroundColor)
                    
                    Rectangle()
                        .fill(fillColor)
                        .frame(width: min(CGFloat(self.value / self.total) * geometry.size.width, geometry.size.width))
                }
            }
            .frame(height: 10)
            .cornerRadius(5)
        }
    }
}


// Mock data
let mockReceipt = Receipt(
    id: "1",
    name: "Dinner at Luigi's",
    date: "2024-07-15",
    items: [
        Item(id: "1", name: "Pizza", price: 10.00, claimedBy: ["1"]),
        Item(id: "2", name: "Veal", price: 10.00, claimedBy: ["1"]),
        Item(id: "3", name: "Chicken Parm", price: 10.00, claimedBy: ["1"]),
        Item(id: "4", name: "White Wine", price: 10.00),
        Item(id: "5", name: "Pizza2", price: 10.00),
        Item(id: "6", name: "Red Wine", price: 10.00)
    ],
    people: [
        LegitP(id: "1", name: "Alice"),
        LegitP(id: "2", name: "Bob"),
        LegitP(id: "3", name: "Charlie"),
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
