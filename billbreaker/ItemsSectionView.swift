//
//  ItemsSectionView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct ItemsSectionView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receipt: Receipt
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(receipt.items ?? [], id: \.id) { item in
                let users = self.getUsersForItem(item: item)
                
                ItemRowView(item: item, users: users, rviewModel: rviewModel)
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .frame(maxWidth: .infinity) // Adjust width dynamically
        .shadow(radius: 1)
    }
    
    private func getUsersForItem(item: Item) -> [LegitP] {
        return receipt.people?.filter { $0.claims.contains { $0 == item.id } } ?? []
    }
}

