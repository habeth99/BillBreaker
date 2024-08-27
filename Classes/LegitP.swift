//
//  LegitP.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation
import SwiftUI

class LegitP: Identifiable, ObservableObject, Codable {
    @Published var id: String
    @Published var name: String
    @Published var userId: String
    @Published var claims: [String]
    @Published var paid: Bool
    @Published var color: Color
    
    enum CodingKeys: CodingKey {
        case id, name, userId, claims, paid, color
    }
    
    // Custom initializer
    init(id: String = "", name: String = "", userId: String = "", claims: [String] = [], paid: Bool = false, color: Color = .red) {
        self.id = id
        self.name = name
        self.userId = userId
        self.claims = claims
        self.paid = paid
        self.color = color
    }
    
    // Required for Codable conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? "BAD9"
        claims = try container.decodeIfPresent([String].self, forKey: .claims) ?? []
        paid = try container.decodeIfPresent(Bool.self, forKey: .paid) ?? false
        color = LegitP.strToColor[try container.decodeIfPresent(String.self, forKey: .color) ?? "red"] ?? .red
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(userId, forKey: .userId)
        try container.encode(claims, forKey: .claims)
        try container.encode(paid, forKey: .paid)
        try container.encode(LegitP.colorToStr[color], forKey: .color)
    }
    
    func toDict() -> [String: Any] {
        return [
            "id": self.id,
            "name": self.name,
            "userId": self.userId,
            "claims": self.claims,
            "color": LegitP.colorToStr[self.color]!
        ]
    }
    
    var description: String {
        return "LegitP(id: \(id), name: \(name), userId: \(userId), claims: \(claims), paid: \(paid))"
    }
    
    static let colorToStr: [Color: String] = [
        .red: "red",
        .blue: "blue",
        .green: "green",
        .orange: "orange",
        .yellow: "yellow",
        .gray: "gray",
        .purple: "purple",
        .pink: "pink"
    ]
    
    static let strToColor: [String: Color] = [
        "red": .red,
        "blue": .blue,
        "green": .green,
        "orange": .orange,
        "yellow": .yellow,
        "gray": .gray,
        "purple": .purple,
        "pink": .pink
    ]
    
    func getFirstInitial() -> String {
        guard let firstChar = name.first else {
            return ""
        }
        return String(firstChar).uppercased()
    }
}
