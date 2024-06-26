//
//  LegitP.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation

class LegitP: Identifiable, ObservableObject, Codable {
    @Published var id: String
    @Published var name: String
    @Published var userId: String
    //@Published var claims: [Item]
    @Published var claims: [String]
    @Published var paid: Bool
    
    enum CodingKeys: CodingKey {
        case id, name, userId, claims, paid
    }

    // Custom initializer
    init(id: String = "", name: String = "", userId: String = "", claims: [String] = [], paid: Bool = false) {
        self.id = id  // Assign a UUID by default or use a specific id if provided
        self.name = name
        self.userId = userId
        self.claims = claims
        self.paid = paid
    }

    // Required for Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? "BAD9"
        
        //try to decode these but not might be present initially thats why we decodeIfPresent
        //claims = try container.decode([String].self, forKey: .claims)
        claims = try container.decodeIfPresent([String].self, forKey: .claims) ?? []
        //paid = try container.decode(Bool.self, forKey: .paid)
        paid = try container.decodeIfPresent(Bool.self, forKey: .paid) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(userId, forKey: .userId)
        try container.encode(claims, forKey: .claims)
        try container.encode(paid, forKey: .paid)
    }
    
    var description: String {
        return "LegitP(id: \(id), name: \(name), userId: \(userId), claims: \(claims), paid: \(paid))"
    }
}
