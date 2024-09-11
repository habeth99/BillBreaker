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
