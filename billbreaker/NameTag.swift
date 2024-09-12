//
//  PersonPill.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct NameTag: View {
    var person: LegitP
    var amountOwed: Decimal
    var receipt: Receipt
    
    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: amountOwed)) ?? "$0.00"
    }
    
    var body: some View {
        Button(action: openLink) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 338, height: 32)
                    .overlay(
                        HStack (spacing: 0){
                            Text(person.name)
                                .foregroundColor(.black)
                                .padding(.horizontal, FatCheckTheme.Spacing.md)
                            Spacer()
                            Text(formattedAmount)
                                .foregroundColor(.black)
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.black)
                                .padding(FatCheckTheme.Spacing.md)
                        }
                    )
            }
            .frame(width: 338, height: 32) // Ensure consistent overall size
            .clipShape(RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs, style: .continuous))
        }
    }
    
    func openLink() {
        receipt.sharePersonalCheck(receiptId: receipt.id, personName: person.name, receiptName: receipt.name)
    }
}

