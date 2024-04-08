//
//  User.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import FirebaseDatabase

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var venmoHandle: String
    var cashAppHandle: String
    var receipts: [String]

    enum CodingKeys: CodingKey {
        case id, name, email, venmoHandle, cashAppHandle, receipts
    }

    // Modified custom initializer
    init(id: String? = nil, name: String, email: String, venmoHandle: String, cashAppHandle: String, receipts: [String] = []) {
        self.id = id ?? UUID().uuidString // Use provided id or generate a new UUID
        self.name = name
        self.email = email
        self.venmoHandle = venmoHandle
        self.cashAppHandle = cashAppHandle
        self.receipts = receipts
    }

    // Required for Codable conformance remains unchanged
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        venmoHandle = try container.decode(String.self, forKey: .venmoHandle)
        cashAppHandle = try container.decode(String.self, forKey: .cashAppHandle)
        receipts = try container.decode([String].self, forKey: .receipts)
    }

}







