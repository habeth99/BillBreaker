//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation

class Receipt: Codable, Identifiable, ObservableObject, CustomStringConvertible {
    @Published var id: String
    @Published var userId: String
    @Published var name: String
    @Published var date: String
    @Published var createdAt: String
    @Published var tax: Double
    @Published var tip: Double
    @Published var items: [Item]?
    @Published var people: [LegitP]?
    
    enum CodingKeys: CodingKey {
        case id, userId, name, date, createdAt, tax, tip, items, people
    }

    // Custom initializer
    init(id: String = "", userId: String = "", name: String = "", date: String = "", createdAt: String = "", tax: Double = 0.00, tip: Double = 0.00, items: [Item] = [], people: [LegitP] = []) {
        self.id = id // Assign a UUID by default or use a specific id if provided
        self.userId = userId
        self.name = name
        self.date = date
        self.createdAt = createdAt
        self.tax = tax
        self.tip = tip
        self.items = items
        self.people = people
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //print("Decoding id")
        id = try container.decode(String.self, forKey: .id)
        
        //print("Decoding userId")
        userId = try container.decode(String.self, forKey: .userId)
        
        //print("Decoding name")
        name = try container.decode(String.self, forKey: .name)
        
        //print("Decoding date")
        date = try container.decode(String.self, forKey: .date)
        
        //print("Decoding createdAt")
        createdAt = try container.decode(String.self, forKey: .createdAt)
        
        //print("Decoding tax")
        tax = try container.decode(Double.self, forKey: .tax)
        
        tip = try container.decode(Double.self, forKey: .tip)
        
        //print("Decoding items")
        //items = try container.decode([Item].self, forKey: .items)
        items = try container.decodeIfPresent([Item].self, forKey: .items) ?? []
        
        //print("Decoding people")
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
        try container.encode(tip, forKey: .tip)
        try container.encodeIfPresent(items, forKey: .items)
        try container.encodeIfPresent(people, forKey: .people)
    }
    
    //====================================================================================//
    //                               Receipt Class Functions                              //
    //====================================================================================//
    
    func findItemById(id: String) -> Item? {
        return self.items?.first { $0.id == id }
    }
    
    func countPeopleClaiming(itemID: String) -> Int {
        return people?.reduce(0) { (count, person) in
            return count + (person.claims.contains(itemID) ? 1 : 0)
        } ?? 0
    }
    
    func calcTipShare(user: LegitP, userTotal: Double) -> Double {
        var sharedTip = 0.0
        var total = 0.0
        
        total = getTotal()
        
        sharedTip = userTotal/total
        sharedTip = sharedTip * self.tip
        
        return sharedTip
    }
    
    func calcTaxShare(){
        //TODO
    }
    
    func getTotal() -> Double {
        var total = 0.0
        
        for item in self.items ?? [] {
            total += item.price
        }
        
        return total
    }
    
    var description: String {
        return "Receipt(id: \(id), userId: \(userId), name: \(name), date: \(date), createdAt: \(createdAt), tax: \(tax), items: \(items ?? []), people: \(people ?? []))"
    }
}
