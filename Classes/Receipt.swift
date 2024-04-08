//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation

struct Receipt: Codable, Identifiable {
    var id: String
    var userId: String
    var name: String
    var date: String
    var createdAt: String
    var tax: Double
    var price: Double
    var items: [String]
    var people: [String]
    
    enum CodingKeys: CodingKey {
        case id, userId, name, date, createdAt, tax, price, items, people
    }

    // Custom initializer
    init(id: String = UUID().uuidString, userId: String, name: String, date: String, createdAt: String, tax: Double, price: Double, items: [String] = [], people: [String] = []) {
        self.id = id // Assign a UUID by default or use a specific id if provided
        self.userId = userId
        self.name = name
        self.date = date
        self.createdAt = createdAt
        self.tax = tax
        self.price = price
        self.items = items
        self.people = people
    }

    // Required for Codable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(String.self, forKey: .date)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        tax = try container.decode(Double.self, forKey: .tax)
        price = try container.decode(Double.self, forKey: .price)
        items = try container.decode([String].self, forKey: .items)
        people = try container.decode([String].self, forKey: .people)
    }
}
