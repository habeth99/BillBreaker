//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.

import Foundation

class Item: Identifiable, Codable, ObservableObject, Hashable, CustomStringConvertible {
    @Published var id: String
    @Published var name: String
    @Published var quantity: Int?
    @Published var price: Decimal
    //@Published var claimedBy: [String]?
    @Published var claimedBy: [String]?
    @Published var details: String

    enum CodingKeys: CodingKey {
        case id, name, quantity, price, claimedBy, details
    }

    init(id: String = "", name: String = "", quantity: Int = 0, price: Decimal = 0.00, claimedBy: [String] = [], details: String = "") {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.price = price
        self.claimedBy = claimedBy
        self.details = details
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        price = try container.decode(Decimal.self, forKey: .price)
        claimedBy = try container.decodeIfPresent([String].self, forKey: .claimedBy) ?? []
        details = try container.decodeIfPresent(String.self, forKey: .details) ?? ""
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.quantity == rhs.quantity &&
               lhs.price == rhs.price &&
               lhs.claimedBy == rhs.claimedBy
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(price, forKey: .price)
        try container.encode(claimedBy, forKey: .claimedBy)
    }
    
    var description: String {
        return "Item(id: \(id), name: \(name), price: \(price), quantity: \(quantity ?? 0), claimedBy: \(claimedBy ?? []))"
    }
    

}
