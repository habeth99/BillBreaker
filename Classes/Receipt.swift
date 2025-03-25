//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import Firebase
import SwiftUI

class Receipt: Codable, Identifiable, ObservableObject, CustomStringConvertible {
    @Published var id: String
    @Published var userId: String
    @Published var name: String
    @Published var date: String
    @Published var createdAt: String
    @Published var tax: Decimal
    @Published var tip: Decimal
    @Published var items: [Item]?
    @Published var people: [LegitP]?
    // NEW PROPERTIES
    @Published var restaurantName: String
    @Published var restaurantAddress: String
    @Published var dateTime: String
    @Published var subTotal: Decimal
    @Published var total: Decimal
    @Published var paymentMethod: String
    @Published var cardLastFour: String
    
    private let dbRef = Database.database().reference()
    
    enum CodingKeys: String, CodingKey {
        case restaurant, items, summary, payment
        case id, userId, name, date, createdAt, tax, tip, people
    }
    
    enum RestaurantKeys: String, CodingKey {
        case name, address, dateTime
    }
    
    enum SummaryKeys: String, CodingKey {
        case subTotal, tax, tip, total
    }
    
    enum PaymentKeys: String, CodingKey {
        case method, cardLastFour
    }


    init(id: String = "", userId: String = "", name: String = "", date: String = "", createdAt: String = "", tax: Decimal = 0.00, tip: Decimal = 0.00, items: [Item] = [], people: [LegitP] = [], restaurantName: String = "", restaurantAddress: String = "", dateTime: String = "", subTotal: Decimal = 0.0, total: Decimal = 0.0, paymentMethod: String = "", cardLastFour: String = ""
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.date = date
        self.createdAt = createdAt
        self.tax = tax
        self.tip = tip
        self.items = items
        self.people = people
        
        self.restaurantName = restaurantName
        self.restaurantAddress = restaurantAddress
        self.dateTime = dateTime
        self.subTotal = subTotal
        self.total = total
        self.paymentMethod = paymentMethod
        self.cardLastFour = cardLastFour
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //print("Decoding id")
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? "BAD47"
        
        //print("Decoding userId")
        userId = try container.decodeIfPresent(String.self, forKey: .userId) ?? "BAD48"
        
        //print("Decoding name")
        name = try container.decode(String.self, forKey: .name)
        
        //print("Decoding date")
        date = try container.decode(String.self, forKey: .date)
        
        //print("Decoding createdAt")
        createdAt = try container.decode(String.self, forKey: .createdAt)
        
        //print("Decoding tax")
        tax = try container.decode(Decimal.self, forKey: .tax)
        
        tip = try container.decode(Decimal.self, forKey: .tip)
        
        //print("Decoding items")
        //items = try container.decode([Item].self, forKey: .items)
        items = try container.decodeIfPresent([Item].self, forKey: .items) ?? []
        
        //print("Decoding people")
        //people = try container.decode([LegitP].self, forKey: .people)
        people = try container.decodeIfPresent([LegitP].self, forKey: .people) ?? []
        
                self.restaurantName = ""
                self.restaurantAddress = ""
                self.dateTime = ""
                self.subTotal = 0.0
                self.total = 0.0
                self.paymentMethod = ""
                self.cardLastFour = ""
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
    
    //====================================================================================
    // functions for calculating totals for amounts owed
    
    func findItemById(id: String) -> Item? {
        return self.items?.first { $0.id == id }
    }
    
    func countPeopleClaiming(itemID: String) -> Int {
        return people?.reduce(0) { (count, person) in
            return count + (person.claims.contains(itemID) ? 1 : 0)
        } ?? 0
    }
    
    func getTotal() -> Decimal {
        var total = Decimal()
        for item in self.items ?? [] {
            total += item.price // Assuming item.price is Decimal
        }
        
        total = total + self.tip + self.tax // Assuming self.tip and self.tax are Decimal
        return total
    }
    
    private func calculatePersonAmount(_ person: LegitP) -> Decimal {
        guard let items = items else { return Decimal(0) }

        let claimedItemsAmount = person.claims.compactMap { claimedItemId -> Decimal? in
            guard let item = items.first(where: { $0.id == claimedItemId }) else {
                return nil
            }
            let peopleClaimingItem = Decimal(countPeopleClaiming(itemID: claimedItemId))
            return item.price / peopleClaimingItem
        }.reduce(Decimal(0), +)
        
        let totalItemsPrice = items.reduce(Decimal(0)) { $0 + $1.price }
        let personShare = claimedItemsAmount / totalItemsPrice
        let taxShare = personShare * tax
        let tipShare = personShare * tip
        
        return claimedItemsAmount + taxShare + tipShare
    }

//    func calculateStillOwed() -> Decimal {
//        guard let people = people, let items = items else {
//            return Decimal(0)
//        }
//        // Calculate the total of all items, tax, and tip
//        let totalAmount = items.reduce(Decimal(0)) { $0 + $1.price } + tax + tip
//        var amountPaid = Decimal(0)
//        // Find the user (assuming user has a non-empty userId)
//        if let user = people.first(where: { !$0.userId.isEmpty }) {
//            if !user.claims.isEmpty {
//                // If the user has claimed items, subtract their amount
//                amountPaid += calculatePersonAmount(user)
//            }
//        }
//        // Subtract amounts for all paid people (excluding the user if already counted)
//        for person in people {
//            
//            if person.paid && person.userId.isEmpty {
//                amountPaid += calculatePersonAmount(person)
//            }
//        }
//        // Calculate the amount still owed
//        let stillOwed = totalAmount - amountPaid
//        return max(stillOwed, Decimal(0))
//    }
    func calculateStillOwed() -> Decimal {
        guard let people = people, let items = items else {
            return Decimal(0)
        }
        
        // Calculate the total of all items, tax, and tip
        let totalAmount = items.reduce(Decimal(0)) { $0 + $1.price } + tax + tip
        var amountPaid = Decimal(0)
        
        // Find the receipt creator (the real user who created the receipt)
        if let receiptCreator = people.first(where: { $0.userId == self.userId }) {
            // Treat the receipt creator as paid
            amountPaid += calculatePersonAmount(receiptCreator)
        }
        
        // Subtract amounts for all other paid people
        for person in people {
            if person.paid && person.userId != self.userId {
                amountPaid += calculatePersonAmount(person)
            }
        }
        
        // Calculate the amount still owed
        let stillOwed = totalAmount - amountPaid
        return max(stillOwed, Decimal(0))
    }

    func amountOwedByPerson(_ personId: String) -> Decimal {
        guard let person = people?.first(where: { $0.id == personId }) else {
            return 0.0
        }
        
        if person.claims.isEmpty {
            // If this person has no claims, return 0
            return 0.0
        }
        
        let claimedItemsTotalPrice = person.claims.reduce(Decimal(0)) { total, claimedItemId in
            guard let item = items?.first(where: { $0.id == claimedItemId }) else {
                return total
            }
            let peopleClaimingItem = max(countPeopleClaiming(itemID: claimedItemId), 1)
            let itemShare = item.price / Decimal(peopleClaimingItem)
            return total + itemShare
        }

        let totalClaimedPrice = (items ?? []).reduce(Decimal(0)) { $0 + $1.price }
        let personShare = totalClaimedPrice > 0 ? claimedItemsTotalPrice / totalClaimedPrice : 0
        let taxShare = personShare * tax
        let tipShare = personShare * tip

        return claimedItemsTotalPrice + taxShare + tipShare
    }
    
    // end calculation functions
    //=========================================================================================
    
    func deleteItem(id: String) {
        items?.removeAll { $0.id == id }
        for person in people ?? [] {
            person.claims.removeAll { $0 == id }
        }
    }
    
    func deletePerson(id: String) {
        people?.removeAll { $0.id == id }
    }
    
    func formatDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this format to match your date string format
        
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    func sharePersonalCheck(receiptId: String, personName: String, receiptName: String) {
        // Create a web URL for your app
        let webURLString = "https://www.fatcheck.app/receipt/\(receiptId)"
        guard let url = URL(string: webURLString) else { return }
        
        // Create the personalized message
        let message = "Hey \(personName), you need to pay your check from \(receiptName)"
        
        // Combine the message and the URL
        let shareText = "\(message)\n\(webURLString)"
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // Present the view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    var description: String {
        return "Receipt(id: \(id), userId: \(userId), name: \(name), date: \(date), createdAt: \(createdAt), tax: \(tax), items: \(items ?? []), people: \(people ?? []))"
    }
    
    static func getUserdId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
}

extension Receipt {
    static func from(apiReceipt: APIReceipt) -> Receipt {
        let receipt = Receipt(
            id: "",
            userId: "",
            name: apiReceipt.name,
            date: Date().ISO8601Format(),
                //apiReceipt.dateTime,
            createdAt: Date().ISO8601Format(),
            tax: apiReceipt.tax,
            tip: apiReceipt.tip,
            items: apiReceipt.items.map { Item(id: "", name: $0.name, quantity: $0.quantity, price: $0.price) },
            people: [],
            restaurantAddress: apiReceipt.address,
            subTotal: apiReceipt.subTotal,
            total: apiReceipt.total,
            paymentMethod: apiReceipt.method ?? "",
            cardLastFour: apiReceipt.cardLastFour ?? ""
        )
        return receipt
    }
}
