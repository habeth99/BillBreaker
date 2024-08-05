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
        List(rviewModel.receiptList, id: \.id) { receipt in
            Button(action: {
                router.linkReceiptId = receipt.id
//                router.path.append("BillDetails")
                router.navigate(to: .billDetails(receiptId: router.linkReceiptId))
            }) {
                ReceiptRow(receipt: receipt)
            }
        }
    }
}
