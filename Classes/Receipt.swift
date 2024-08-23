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
    @Published var tax: Double
    @Published var tip: Double
    @Published var items: [Item]?
    @Published var people: [LegitP]?
    // NEW PROPERTIES
    @Published var restaurantName: String
    @Published var restaurantAddress: String
    @Published var dateTime: String
    @Published var subTotal: Double
    @Published var total: Double
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


    init(id: String = "", userId: String = "", name: String = "", date: String = "", createdAt: String = "", tax: Double = 0.00, tip: Double = 0.00, items: [Item] = [], people: [LegitP] = [], restaurantName: String = "", restaurantAddress: String = "", dateTime: String = "", subTotal: Double = 0.0, total: Double = 0.0, paymentMethod: String = "", cardLastFour: String = ""
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
        tax = try container.decode(Double.self, forKey: .tax)
        
        tip = try container.decode(Double.self, forKey: .tip)
        
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
        
        total = total + self.tip + self.tax
        
        return total
    }
    
    func amtOwed() -> Double {
        guard let people = people, let items = items else {
            return 0.0
        }

        var totalOwed = 0.0

        for person in people {
            let claimedItemsTotalPrice = person.claims.compactMap { claimedItemId -> Double? in
                guard let item = items.first(where: { $0.id == claimedItemId }) else {
                    return nil
                }
                let peopleClaimingItem = countPeopleClaiming(itemID: claimedItemId)
                return item.price / Double(peopleClaimingItem)
            }.reduce(0, +)

            totalOwed += claimedItemsTotalPrice
        }

        // Add tax and tip to the total
        totalOwed += tax + tip

        return totalOwed
    }
    
//    func amountOwedByPerson(_ personId: String) -> Double {
//        guard let person = people?.first(where: { $0.id == personId }) else {
//            return 0.0
//        }
//
//        let claimedItemsTotalPrice = person.claims.compactMap { claimedItemId -> Double? in
//            guard let item = items?.first(where: { $0.id == claimedItemId }) else {
//                return nil
//            }
//            let peopleClaimingItem = countPeopleClaiming(itemID: claimedItemId)
//            return item.price / Double(peopleClaimingItem)
//        }.reduce(0, +)
//
//        let taxShare = (claimedItemsTotalPrice / subTotal) * tax
//        let tipShare = (claimedItemsTotalPrice / subTotal) * tip
//
//        return claimedItemsTotalPrice + taxShare + tipShare
//    }
//    func amountOwedByPerson(_ personId: String) -> Double {
//        guard let person = people?.first(where: { $0.id == personId }) else {
//            return 0.0
//        }
//
//        let claimedItemsTotalPrice = person.claims.compactMap { claimedItemId -> Double? in
//            guard let item = items?.first(where: { $0.id == claimedItemId }) else {
//                return nil
//            }
//            let peopleClaimingItem = max(countPeopleClaiming(itemID: claimedItemId), 1)
//            return item.price / Double(peopleClaimingItem)
//        }.reduce(0, +)
//
//        // Guard against division by zero
//        guard subTotal > 0 else {
//            return claimedItemsTotalPrice
//        }
//
//        let taxShare = (claimedItemsTotalPrice / subTotal) * tax
//        let tipShare = (claimedItemsTotalPrice / subTotal) * tip
//
//        return claimedItemsTotalPrice + taxShare + tipShare
//    }
//    func amountOwedByPerson(_ personId: String) -> Double {
//        guard let person = people?.first(where: { $0.id == personId }),
//              let items = items,
//              subTotal > 0 else {
//            return 0.0
//        }
//
//        let claimedItemsTotalPrice = person.claims.reduce(0.0) { total, claimedItemId in
//            guard let item = items.first(where: { $0.id == claimedItemId }) else {
//                return total
//            }
//            let peopleClaimingItem = max(countPeopleClaiming(itemID: claimedItemId), 1)
//            return total + (item.price / Double(peopleClaimingItem))
//        }
//
//        // Calculate the person's share of the subtotal
//        let personShare = claimedItemsTotalPrice / subTotal
//
//        // Calculate tax and tip share based on the person's share of the subtotal
//        let taxShare = personShare * tax
//        let tipShare = personShare * tip
//
//        return claimedItemsTotalPrice + taxShare + tipShare
//    }
//    func amountOwedByPerson(_ personId: String) -> Double {
//
//        print("Calculating amount owed for person: \(personId)")
//        print("People in receipt: \(people?.map { "\($0.id): \($0.name)" } ?? [])")
//        print("Items in receipt: \(items?.map { "\($0.id): \($0.name)" } ?? [])")
//        print("Subtotal: \(subTotal)")
//
//        guard let person = people?.first(where: { $0.id == personId }) else {
//            print("Person not found")
//            return 0.0
//        }
//        guard let items = items, !items.isEmpty else {
//            print("Items array is empty or nil")
//            return 0.0
//        }
//        guard subTotal > 0 else {
//            print("Subtotal is zero or negative")
//            return 0.0
//        }
//
//
//        let claimedItemsTotalPrice = person.claims.reduce(0.0) { total, claimedItemId in
//            guard let item = items.first(where: { $0.id == claimedItemId }) else {
//                print("Item not found for claim \(claimedItemId)")
//                return total
//            }
//            let peopleClaimingItem = max(countPeopleClaiming(itemID: claimedItemId), 1)
//            let itemShare = item.price / Double(peopleClaimingItem)
//            print("Item \(item.name): price = \(item.price), people claiming = \(peopleClaimingItem), share = \(itemShare)")
//            return total + itemShare
//        }
//
//        let personShare = claimedItemsTotalPrice / subTotal
//        let taxShare = personShare * tax
//        let tipShare = personShare * tip
//        
//        let totalOwed = claimedItemsTotalPrice + taxShare + tipShare
//        print("Person \(personId): claimed total = \(claimedItemsTotalPrice), tax share = \(taxShare), tip share = \(tipShare), total owed = \(totalOwed)")
//        return totalOwed
//    }
    func amountOwedByPerson(_ personId: String) -> Double {
        print("Calculating amount owed for person: \(personId)")
        print("People in receipt: \(people?.map { "\($0.id): \($0.name)" } ?? [])")
        print("Items in receipt: \(items?.map { "\($0.id): \($0.name) - $\($0.price)" } ?? [])")
        
        guard let person = people?.first(where: { $0.id == personId }) else {
            print("Person not found")
            return 0.0
        }
        guard let items = items, !items.isEmpty else {
            print("Items array is empty or nil")
            return 0.0
        }
        
        let subtotal = calculatedSubTotal
        print("Calculated subtotal: \(subtotal)")
        
        guard subtotal > 0 else {
            print("Calculated subtotal is zero or negative")
            return 0.0
        }

        let claimedItemsTotalPrice = person.claims.reduce(0.0) { total, claimedItemId in
            guard let item = items.first(where: { $0.id == claimedItemId }) else {
                print("Item not found for claim \(claimedItemId)")
                return total
            }
            let peopleClaimingItem = max(countPeopleClaiming(itemID: claimedItemId), 1)
            let itemShare = item.price / Double(peopleClaimingItem)
            print("Item \(item.name): price = \(item.price), people claiming = \(peopleClaimingItem), share = \(itemShare)")
            return total + itemShare
        }

        let personShare = claimedItemsTotalPrice / subtotal
        let taxShare = personShare * tax
        let tipShare = personShare * tip
        
        let totalOwed = claimedItemsTotalPrice + taxShare + tipShare
        print("Person \(personId): claimed total = \(claimedItemsTotalPrice), tax share = \(taxShare), tip share = \(tipShare), total owed = \(totalOwed)")
        return totalOwed
    }
    
    var calculatedSubTotal: Double {
        return items?.reduce(0) { $0 + $1.price } ?? 0
    }
    
    func calculateAmountPaid() -> Double {
        return (people ?? [])
            .filter { $0.paid }
            .reduce(0) { $0 + amountOwedByPerson($1.id) }
    }

//    func calculateStillOwed() -> Double {
//        return (people ?? [])
//            .filter { !$0.paid }
//            .reduce(0) { $0 + amountOwedByPerson($1.id) }
//    }
//    func calculateStillOwed() -> Double {
//        let stillOwed = (people ?? [])
//            .filter { !$0.paid }
//            .reduce(0) { $0 + amountOwedByPerson($1.id) }
//        print("Calculate still owed for receipt \(id): \(stillOwed)")
//        return stillOwed
//    }
    func calculateStillOwed() -> Double {
        print("Calculating still owed for receipt \(id)")
        print("People: \(people?.map { "\($0.id): \($0.name) (paid: \($0.paid))" } ?? [])")
        print("Calculated subtotal: \(calculatedSubTotal)")
        
        let stillOwed = (people ?? [])
            .filter { !$0.paid }
            .reduce(0) { $0 + amountOwedByPerson($1.id) }
        print("Still owed: \(stillOwed)")
        return stillOwed
    }
    
    func countClaimedItems() -> Double {
        let allClaims = people!.compactMap { $0.claims }
        let uniqueClaimedItems = Set(allClaims.flatMap { $0 })
        return Double(uniqueClaimedItems.count)
    }
    
    func countPaidFrnds() -> Double {
        return Double(people?.filter { $0.paid }.count ?? 0)
    }
    
    func formatDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust this format to match your date string format
        
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    var description: String {
        return "Receipt(id: \(id), userId: \(userId), name: \(name), date: \(date), createdAt: \(createdAt), tax: \(tax), items: \(items ?? []), people: \(people ?? []))"
    }
    
    
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//
    //    DATABASE    //    //    DATABASE    //    //    DATABASE    //
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//

//    func fetchUserReceipts() async throws -> [Receipt] {
//        do {
//            let snapshot = try await dbRef.child("users").child(self.userId).getData()
//            guard let userData = snapshot.value as? [String: Any],
//                  let receiptIDs = userData["receipts"] as? [String] else {
//                print("User data or receipts not found")
//                return []
//            }
//            
//            // Assuming fetchReceipts is modified to return [Receipt]
//            let receipts: [Receipt] = try await fetchReceipts(receiptIDs: receiptIDs)
//            return receipts
//        } catch {
//            print("Error fetching user data: \(error.localizedDescription)")
//            throw error  // Re-throw the error to be handled by the caller
//        }
//    }
    
//    private func fetchReceipts(receiptIDs: [String]) async -> [Receipt] {
//        var fetchedReceipts: [Receipt] = []
//
//        for receiptID in receiptIDs {
//            do {
//                let snapshot = try await dbRef.child("receipts").child(receiptID).getData()
//                guard let receiptData = snapshot.value as? [String: Any] else {
//                    print("Receipt data not found for ID: \(receiptID)")
//                    continue
//                }
//                
//                let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
//                let receipt = try JSONDecoder().decode(Receipt.self, from: data)
//                if !fetchedReceipts.contains(where: { $0.id == receipt.id }) {
//                    fetchedReceipts.append(receipt)
//                }
//            } catch {
//                print("Error decoding receipt: \(error.localizedDescription)")
//            }
//        }
//
//        print("All receipts fetched: \(fetchedReceipts)")
//        
//        if !listenersSetUp {
//            setupReceiptListeners(receiptIDs: receiptIDs)
//        } else {
//            print("Listeners already set up, skipping setup")
//        }
//        
//        return fetchedReceipts
//    }
    
//
//    func getReceipt(id: String) async -> Receipt? {
//        reset()
//        do {
//            let snapshot = try await dbRef.child("receipts").child(id).getData()
//            
//            guard let value = snapshot.value as? [String: Any] else {
//                print("Receipt data not found for ID: \(id)")
//                return nil
//            }
//            
//            print("Receipt data snapshot value: \(value)")
//            
//            let data = try JSONSerialization.data(withJSONObject: value)
//            let loadedReceipt = try JSONDecoder().decode(Receipt.self, from: data)
//            
//            self.receipt = loadedReceipt
//            //print("Receipt loaded: \(loadedReceipt.name)")
//            
//            // Temp variables to match what the methods need
//            let tempReceiptList = [id]
//            let receiptRef = dbRef.child("receipts").child(id)
//            // Set up listeners for real-time updates
//            setupReceiptListeners(receiptIDs: tempReceiptList)
//            setupPeopleListeners(receiptRef, receiptID: id)
//            setupItemListeners(receiptRef, receiptID: id)
//            
//            return self.receipt
//        } catch {
//            print("Error loading receipt: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    static func getUserdId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//
    //    DATABASE    //    //    DATABASE    //    //    DATABASE    //
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//
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
