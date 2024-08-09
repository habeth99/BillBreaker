//
//  ProReceipt.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/29/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Combine

class APIReceipt: Codable {
    
    let name: String
    let address: String
    let dateTime: String
    let items: [Item]
    
    struct Item: Codable {
        let quantity: Int
        let name: String
        let price: Double
        let details: String
    }
    let subTotal: Double
    let tax: Double
    let tip: Double
    let total: Double
    let method: String?
    let cardLastFour: String?
    
    init(
        name: String = "",
        address: String = "",
        dateTime: String = "",
        items: [Item] = [],
        subTotal: Double = 0.0,
        tax: Double = 0.0,
        tip: Double = 0.0,
        total: Double = 0.0,
        method: String? = nil,
        cardLastFour: String? = nil
    ) {
        self.name = name
        self.address = address
        self.dateTime = dateTime
        self.items = items
        self.subTotal = subTotal
        self.tax = tax
        self.tip = tip
        self.total = total
        self.method = method
        self.cardLastFour = cardLastFour
    }

    
    
}
