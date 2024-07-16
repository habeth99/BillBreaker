//
//  ReceiptRowView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

struct ReceiptRow: View {
    let receipt: Receipt
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(receipt.name).font(.headline)
            Text("Date: \(receipt.date)").font(.subheadline)
            Text("Total: $\(receipt.getTotal(), specifier: "%.2f")").font(.subheadline)
        }
    }
}
