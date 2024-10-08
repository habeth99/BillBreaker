//
//  Item.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import Firebase

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
    
//    enum CodingKeys: CodingKey {
//        case id, userId, name, date, createdAt, tax, tip, items, people
//    }
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
        
        return total
    }
    
    var description: String {
        return "Receipt(id: \(id), userId: \(userId), name: \(name), date: \(date), createdAt: \(createdAt), tax: \(tax), items: \(items ?? []), people: \(people ?? []))"
    }
    
    
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//
    //    DATABASE    //    //    DATABASE    //    //    DATABASE    //
    //++++++++++++++++//    //++++++++++++++++//    //++++++++++++++++//
    
    
//    func fetchUserReceipts() async {
//        guard let userID = userViewModel.currentUser?.id else {
//            print("fetchUserReceipts: User not authenticated or user ID not available")
//            return
//        }
//        
//        do {
//            let snapshot = try await dbRef.child("users").child(userID).getData()
//            guard let userData = snapshot.value as? [String: Any],
//                  let receiptIDs = userData["receipts"] as? [String] else {
//                print("User data or receipts not found")
//                return
//            }
//            await fetchReceipts(receiptIDs: receiptIDs)
//        } catch {
//            print("Error fetching user data: \(error.localizedDescription)")
//        }
//    }
//    
//    private func fetchReceipts(receiptIDs: [String]) async {
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
//                //print("Receipt data snapshot value for \(receiptID): \(receiptData)")
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
//        self.receiptList = fetchedReceipts
//        print("All receipts fetched: \(self.receiptList)")
//        
//        if !listenersSetUp {
//            setupReceiptListeners(receiptIDs: receiptIDs)
//        } else {
//            print("Listeners already set up, skipping setup")
//        }
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
            date: apiReceipt.dateTime,
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
