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
        ScrollView {
            VStack (spacing: 0) {
                StatboardView()
                HStack (spacing: 0) {
                    Text("Recent Checks")
                        .padding(.horizontal, FatCheckTheme.Spacing.sm)
                        //.padding(FatCheckTheme.Spacing.sm)
                    Spacer()
                }
            }
            
            VStack (spacing: 0) {
                ForEach(rviewModel.receiptList, id: \.id) { receipt in
                    CheckCard(receipt: receipt)
                }
            }
        }
        .background(Color.gray.opacity(0.2))
    }
}
