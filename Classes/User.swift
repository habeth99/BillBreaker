//
//  User.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import FirebaseDatabase

class User: Identifiable, Codable, ObservableObject {
    @Published var id: String
    @Published var name: String
    @Published var email: String
    @Published var venmoHandle: String
    @Published var cashAppHandle: String
    @Published var receipts: [String]?

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
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        print("Decoding id")
        id = try container.decode(String.self, forKey: .id)
        
        print("Decoding name")
        name = try container.decode(String.self, forKey: .name)
        
        print("Decoding email")
        email = try container.decode(String.self, forKey: .email)
        
        print("Decoding venmoHandle")
        venmoHandle = try container.decode(String.self, forKey: .venmoHandle)
        
        print("Decoding cashAppHandle")
        cashAppHandle = try container.decode(String.self, forKey: .cashAppHandle)
        
        print("Decoding receipts")
        receipts = try container.decodeIfPresent([String].self, forKey: .receipts) ?? []
        
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        email = try container.decode(String.self, forKey: .email)
//        venmoHandle = try container.decode(String.self, forKey: .venmoHandle)
//        cashAppHandle = try container.decode(String.self, forKey: .cashAppHandle)
//        receipts = try container.decodeIfPresent([String].self, forKey: .receipts)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(venmoHandle, forKey: .venmoHandle)
        try container.encode(cashAppHandle, forKey: .cashAppHandle)
        try container.encode(receipts, forKey: .receipts)
    }
    
    var description: String {
        return "User(id: \(id), name: \(name), email: \(email), venmoHandle: \(venmoHandle), cashAppHandle: \(cashAppHandle), receipts: \(receipts))"
    }
}







