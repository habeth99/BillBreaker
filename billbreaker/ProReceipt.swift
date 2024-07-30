//
//  ProReceipt.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/29/24.
//

import Foundation

struct APIReceipt: Codable {
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
}
