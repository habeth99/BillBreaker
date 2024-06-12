//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation

class Receipt: Codable, Identifiable, ObservableObject {
    @Published var id: String
    @Published var userId: String
    @Published var name: String
    @Published var date: String
    @Published var createdAt: String
    @Published var tax: Double
    @Published var price: Double
    @Published var items: [Item]?
    @Published var people: [LegitP]?
    
    enum CodingKeys: CodingKey {
        case id, userId, name, date, createdAt, tax, price, items, people
    }

    // Custom initializer
    init(id: String = "", userId: String = "", name: String = "", date: String = "", createdAt: String = "", tax: Double = 0.00, price: Double = 0.00, items: [Item] = [], people: [LegitP] = []) {
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

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        print("Decoding id")
        id = try container.decode(String.self, forKey: .id)
        
        print("Decoding userId")
        userId = try container.decode(String.self, forKey: .userId)
        
        print("Decoding name")
        name = try container.decode(String.self, forKey: .name)
        
        print("Decoding date")
        date = try container.decode(String.self, forKey: .date)
        
        print("Decoding createdAt")
        createdAt = try container.decode(String.self, forKey: .createdAt)
        
        print("Decoding tax")
        tax = try container.decode(Double.self, forKey: .tax)
        
        print("Decoding price")
        price = try container.decode(Double.self, forKey: .price)
        
        print("Decoding items")
        //items = try container.decode([Item].self, forKey: .items)
        items = try container.decodeIfPresent([Item].self, forKey: .items) ?? []
        
        print("Decoding people")
        //people = try container.decode([LegitP].self, forKey: .people)
        people = try container.decodeIfPresent([LegitP].self, forKey: .people) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(tax, forKey: .tax)
        try container.encode(price, forKey: .price)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(people, forKey: .people)
    }
    
    var description: String {
        return "Receipt(id: \(id), userId: \(userId), name: \(name), date: \(date), createdAt: \(createdAt), tax: \(tax), price: \(price), items: \(items ?? []), people: \(people ?? []))"
    }
}
