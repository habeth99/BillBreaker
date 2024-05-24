//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation

struct Item: Identifiable, Codable {
    var id: String
    var name: String
    var quantity: Int?
    var price: Double
    var claimedBy: [String]?
    
    enum CodingKeys: CodingKey {
        case id, name, quantity, price, claimedBy
    }
    
    init (id: String = UUID().uuidString, name: String = "", quantity: Int = 0, price: Double = 0.00, claimedBy: [String] = []){
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.claimedBy = claimedBy
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        //quantity = try container.decode(Int.self, forKey: .quantity)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        price = try container.decode(Double.self, forKey: .price)
        //claimedBy = try container.decode([String].self, forKey: .claimedBy)
        claimedBy = try container.decodeIfPresent([String].self, forKey: .claimedBy)
    }
}
