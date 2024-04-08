//
//  LegitP.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation

struct LegitP: Identifiable, Codable {
    var id: String
    var name: String
    var userId: String
    var claims: [String]
    var paid: Bool
    
    enum CodingKeys: CodingKey {
        case id, name, userId, claims, paid
    }

    // Custom initializer
    init(id: String = UUID().uuidString, name: String, userId: String, claims: [String] = [], paid: Bool = false) {
        self.id = id  // Assign a UUID by default or use a specific id if provided
        self.name = name
        self.userId = userId
        self.claims = claims
        self.paid = paid
    }

    // Required for Codable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        userId = try container.decode(String.self, forKey: .userId)
        claims = try container.decode([String].self, forKey: .claims)
        paid = try container.decode(Bool.self, forKey: .paid)
    }
}
