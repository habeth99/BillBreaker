//
//  ShareButton.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/23/24.
//

import Foundation
import SwiftUI

struct ShareButtonView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        VStack{
//            Button("Share", action: {
//                rviewModel.shareCheck()
//            })
            Button(action: {
                rviewModel.shareCheck(receiptId: rviewModel.receipt.id)
            }) {
                Label("Share Receipt", systemImage: "square.and.arrow.up")
            }
        }
    }
}
