//
//  ReceiptListView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

struct ReceiptListView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        List {
            Section {
                StatboardView(rviewModel: rviewModel)
            }
            
            Section(header: Text("Recent Checks")) {
                ForEach(rviewModel.receiptList, id: \.id) { receipt in
                    CheckCard(receipt: receipt)
                }
                .onDelete(perform: deleteReceipt)
            }
        }
        .refreshable {
            await rviewModel.fetchUserReceipts()
        }
    }
    
    private func deleteReceipt(at offsets: IndexSet) {
        // Implement the delete functionality here
        // For example:
        rviewModel.deleteReceipt(at: offsets)
    }
}
