//
//  ItemRowView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct ItemRowView: View {
    var item: Item
    var users: [LegitP]
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        HStack {
            Text(item.name)
                .padding()
            Spacer()
            Text(String(format: "$%.2f", item.price))
                .padding()
        }
        .onTapGesture {
            if rviewModel.selectedPerson != nil {
                rviewModel.toggleItemSelection(item)
            } else {
                print("No person selected")
            }
        }
    }
}

