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
    
    var body: some View {
        ForEach(rviewModel.receipt.items ?? [], id: \.id) { item in
            let users = self.getUsersForItem(item: item)
            
            ItemRowView(item: item, users: users, rviewModel: rviewModel)
        }
    }
    
    private func getUsersForItem(item: Item) -> [LegitP] {
        return rviewModel.receipt.people?.filter { $0.claims.contains { $0 == item.id } } ?? []
    }
}

