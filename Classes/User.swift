//
//  User.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import FirebaseDatabase

// Make User an ObservableObject to use with SwiftUI
struct User: Identifiable, Codable {
    var id: String
    var name: String
    var venmoHandle: String
    var cashAppHandle: String
    var receipts: [String]

    enum CodingKeys: CodingKey {
        case id, name, venmoHandle, cashAppHandle, receipts
    }

    // Custom initializer
    init(id: String = UUID().uuidString, name: String, venmoHandle: String, cashAppHandle: String, receipts: [String] = []) {
        self.id = id  // Assign a UUID by default or use a specific id if provided
        self.name = name
        self.venmoHandle = venmoHandle
        self.cashAppHandle = cashAppHandle
        self.receipts = receipts
    }

    // Required for Codable conformance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        venmoHandle = try container.decode(String.self, forKey: .venmoHandle)
        cashAppHandle = try container.decode(String.self, forKey: .cashAppHandle)
        receipts = try container.decode([String].self, forKey: .receipts)
    }

}






