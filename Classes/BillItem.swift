//
//  Bill_Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation

struct BillItem: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var price: Double
}
