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
    var items: [Item]?
    var people: [LegitP]?
    
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

    // Required for Codable conformance
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        userId = try container.decode(String.self, forKey: .userId)
//        name = try container.decode(String.self, forKey: .name)
//        date = try container.decode(String.self, forKey: .date)
//        createdAt = try container.decode(String.self, forKey: .createdAt)
//        tax = try container.decode(Double.self, forKey: .tax)
//        price = try container.decode(Double.self, forKey: .price)
//        items = try container.decode([Item].self, forKey: .items)
//        people = try container.decode([LegitP].self, forKey: .people)
//    }
    init(from decoder: Decoder) throws {
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
}
