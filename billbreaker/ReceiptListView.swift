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
    
    var body: some View {
        List(rviewModel.receiptList) { receipt in
            NavigationLink(destination: BillDetailsView(rviewModel: rviewModel, receipt: receipt)) {
                ReceiptRow(receipt: receipt)
            }
        }
    }
}
