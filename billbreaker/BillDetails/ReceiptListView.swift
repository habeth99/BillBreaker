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
//        List(rviewModel.receiptList, id: \.id) { receipt in
//            Button(action: {
//                print("receipt tapped: \(receipt.id)")
//                router.selectedId = receipt.id
//                router.navigateToReceipt(id: receipt.id)
//            }) {
//                ReceiptRow(receipt: receipt)
//            }
//        }
        List(rviewModel.receiptList, id: \.id) { receipt in
            CheckCard(receipt: receipt)
        }
    }
}
