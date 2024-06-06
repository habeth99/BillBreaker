//
//  ReceiptViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

//import Foundation
//import FirebaseDatabase
//import FirebaseAuth
//import Firebase
//import FirebaseFirestoreSwift
//
//class ReceiptViewModel: ObservableObject {
//    @Published var receiptList: [Receipt] = []
//    @Published var receipt: Receipt
//    @Published var items: [Item] = []
//    @Published var people: [LegitP] = []
//    
//    // variable to keep track of user selecting their name on the BillDetailsView
//    @Published var selectedPerson: LegitP?
//    
//    // variable that keeps track of user claiming/selecting items before they are saved to the database
//    @Published var selectedItems: [Item] = []
//
//    var userViewModel: UserViewModel
//    
//    private var dbRef = Database.database().reference()
//    
//    init(user: UserViewModel) {
//        self.userViewModel = user
//        self.receipt = Receipt()
//    }
//    
//    // Function to fetch all receipts for the current user
//    func fetchUserReceipts() {
//        guard let userID = userViewModel.currentUser?.id else {
//            print("fetchUserReceipts: User not authenticated or user ID not available")
//            return
//        }
//
//        // Step 1: Fetch user data
//        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
//            guard let userData = snapshot.value as? [String: Any],
//                  let receiptIDs = userData["receipts"] as? [String] else {
//                print("User data or receipts not found")
//                return
//            }
//
//            // Step 2: Fetch each receipt by ID
//            self.fetchReceipts(receiptIDs: receiptIDs)
//        }) { error in
//            print("Error fetching user data: \(error.localizedDescription)")
//        }
//    }
//
//    // Helper function to fetch receipts based on their IDs
//    private func fetchReceipts(receiptIDs: [String]) {
//        let group = DispatchGroup()
//        var fetchedReceipts: [Receipt] = []
//
//        for receiptID in receiptIDs {
//            group.enter()
//            dbRef.child("receipts").child(receiptID).observeSingleEvent(of: .value, with: { snapshot in
//                defer { group.leave() }
//                guard let receiptData = snapshot.value as? [String: Any] else {
//                    print("Receipt data not found for ID: \(receiptID)")
//                    return
//                }
//                
//                print("Receipt data snapshot value for \(receiptID): \(receiptData)")
//
////                do {
////                    let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
////                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
////                    fetchedReceipts.append(receipt)
////                } catch let error {
////                    print("Error decoding receipt: \(error.localizedDescription)")
////                }
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
//                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
//                    fetchedReceipts.append(receipt)
//                } catch let DecodingError.keyNotFound(key, context) {
//                    print("Missing key: \(key) in context: \(context)")
//                } catch let DecodingError.valueNotFound(value, context) {
//                    print("Missing value: \(value) in context: \(context)")
//                } catch let DecodingError.typeMismatch(type, context) {
//                    print("Type mismatch for type: \(type) in context: \(context)")
//                } catch let DecodingError.dataCorrupted(context) {
//                    print("Data corrupted: \(context)")
//                } catch {
//                    print("Error decoding receipt: \(error.localizedDescription)")
//                }
//            })
//        }
//
//        group.notify(queue: .main) {
//            self.receiptList = fetchedReceipts
//            print("All receipts fetched: \(self.receiptList)")
//        }
//    }
//    
//    func getReceipt() {
//        // TODO
//    }
//    
//    func saveReceipt(completion: @escaping (Bool) -> Void) {
//        var receipt = self.receipt
//        
//        let userId = self.getUser()
//        
//        print("Saving with items: \(receipt.items ?? [])")
//        print("Saving with people: \(receipt.people ?? [])")
//        
//        let receiptRef = dbRef.child("receipts").childByAutoId()
//        let receiptId = receiptRef.key ?? ""
//        self.receipt.id = receiptId
//        receipt.id = self.receipt.id
//        
//        let receiptData: [String: Any] = [
//            "id": receipt.id,
//            "userId": receipt.userId,
//            "name": receipt.name,
//            "date": receipt.date,
//            "createdAt": receipt.createdAt,
//            "tax": receipt.tax,
//            "price": receipt.price,
//            "items": receipt.items?.map { ["id": $0.id, "name": $0.name, "price": $0.price] } ?? [],
//            "people": receipt.people?.map { ["id": $0.id, "name": $0.name] } ?? []
//        ]
//
//        receiptRef.setValue(receiptData) { error, _ in
//            if let error = error {
//                print("Error saving receipt: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                self.userViewModel.addReceiptToUser(userId: userId ?? "BAD7", receiptId: receiptId) { success in
//                    if success {
//                        self.receipt = receipt
//                        completion(true)
//                    } else {
//                        completion(false)
//                    }
//                }
//            }
//        }
//    }
//    
//    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]) {
//        
//        // Get the current date
//        let currentDate = Date()
//
//        // Create a DateFormatter for the date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the format for the date
//        let dateString = dateFormatter.string(from: currentDate)
//
//        // Create a DateFormatter for the time
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "hh:mm:ss a" // Specify the format for the time
//        let timeString = timeFormatter.string(from: currentDate)
//        
//        let id = self.getUser()
//        
//        let newReceipt = Receipt(
//            userId: id ?? "BAD8",
//            name: name,
//            date: dateString,
//            createdAt: timeString,
//            tax: tax,
//            price: price,
//            items: items,
//            people: people
//        )
//        self.receipt = newReceipt
//        print("items IN newreceipt is: \(self.receipt.items)")
//    }
//    
//    func setPeople() {
//        self.people = self.receipt.people!
//        
//        if let currentUser = userViewModel.currentUser {
//            let currentUserPerson = LegitP(id: dbRef.child("people").childByAutoId().key ?? "BAD5", name: currentUser.name)
//            if !people.contains(where: { $0.name == currentUserPerson.name }) {
//                people.append(currentUserPerson)
//            }
//        }
//
//        // Assign a Firebase generated key to each person in the list if they do not already have one
//        for index in people.indices {
//            if people[index].id.isEmpty {
//                people[index].id = dbRef.child("people").childByAutoId().key ?? "BAD6"
//            }
//        }
//
//        // Ensure the receipt.people is populated
//        self.receipt.people = self.people
//    }
//
//    func setItems() {
//        self.items = self.receipt.items!
//        
//        // Assign a Firebase generated key to each item in the list, regardless of their current ID
//        for index in items.indices {
//            if items[index].id.isEmpty {
//                items[index].id = dbRef.child("items").childByAutoId().key ?? "BAD7"
//            }
//        }
//
//        // Ensure the receipt.items is populated
//        self.receipt.items = self.items
//    }
//
//    func getUser() -> String? {
//        return userViewModel.currentUser?.id
//    }
//    
//    func selectPerson(_ person: LegitP) {
//        selectedPerson = person
//        selectedItems = person.claims
//    }
//    
//    func toggleItemSelection(_ item: Item) {
//        guard let selectedPerson = selectedPerson else { return }
//
//        if let index = selectedItems.firstIndex(of: item) {
//            selectedItems.remove(at: index)
//        } else {
//            selectedItems.append(item)
//        }
//        updateClaims(selectedPerson)
//    }
//    
//    private func updateClaims(_ person: LegitP) {
//        if let index = receipt.people?.firstIndex(where: { $0.id == person.id }) {
//            receipt.people?[index].claims = selectedItems
//        }
//    }
//    
//    func addPersonReceipt() {
//        // TODO
//    }
//    
//    func addItemReceipt() {
//        // TODO
//    }
//    
//    func deleteReceipt() {
//        // TODO
//    }
//}

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class ReceiptViewModel: ObservableObject {
    @Published var receiptList: [Receipt] = []
    @Published var receipt: Receipt
    @Published var items: [Item] = []
    @Published var people: [LegitP] = []
    
    // Variable to keep track of user selecting their name on the BillDetailsView
    @Published var selectedPerson: LegitP?
    
    // Variable that keeps track of user claiming/selecting items before they are saved to the database
    @Published var selectedItems: [Item] = []

    var userViewModel: UserViewModel
    
    private var dbRef = Database.database().reference()
    
    init(user: UserViewModel) {
        self.userViewModel = user
        self.receipt = Receipt()
    }
    
    // Function to fetch all receipts for the current user
    func fetchUserReceipts() {
        guard let userID = userViewModel.currentUser?.id else {
            print("fetchUserReceipts: User not authenticated or user ID not available")
            return
        }

        // Step 1: Fetch user data
        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let userData = snapshot.value as? [String: Any],
                  let receiptIDs = userData["receipts"] as? [String] else {
                print("User data or receipts not found")
                return
            }

            // Step 2: Fetch each receipt by ID
            self.fetchReceipts(receiptIDs: receiptIDs)
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }

    // Helper function to fetch receipts based on their IDs
    private func fetchReceipts(receiptIDs: [String]) {
        let group = DispatchGroup()
        var fetchedReceipts: [Receipt] = []

        for receiptID in receiptIDs {
            group.enter()
            dbRef.child("receipts").child(receiptID).observeSingleEvent(of: .value, with: { snapshot in
                defer { group.leave() }
                guard let receiptData = snapshot.value as? [String: Any] else {
                    print("Receipt data not found for ID: \(receiptID)")
                    return
                }
                
                print("Receipt data snapshot value for \(receiptID): \(receiptData)")

                do {
                    let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    fetchedReceipts.append(receipt)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Missing key: \(key) in context: \(context)")
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Missing value: \(value) in context: \(context)")
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type mismatch for type: \(type) in context: \(context)")
                } catch let DecodingError.dataCorrupted(context) {
                    print("Data corrupted: \(context)")
                } catch {
                    print("Error decoding receipt: \(error.localizedDescription)")
                }
            })
        }

        group.notify(queue: .main) {
            self.receiptList = fetchedReceipts
            print("All receipts fetched: \(self.receiptList)")
        }
    }
    
    func getReceipt() {
        // TODO
    }
    
    func saveReceipt(completion: @escaping (Bool) -> Void) {
        var receipt = self.receipt
        
        let userId = self.getUser()
        
        print("Saving with items: \(receipt.items ?? [])")
        print("Saving with people: \(receipt.people ?? [])")
        
        let receiptRef = dbRef.child("receipts").childByAutoId()
        let receiptId = receiptRef.key ?? ""
        self.receipt.id = receiptId
        receipt.id = self.receipt.id
        
        let receiptData: [String: Any] = [
            "id": receipt.id,
            "userId": receipt.userId,
            "name": receipt.name,
            "date": receipt.date,
            "createdAt": receipt.createdAt,
            "tax": receipt.tax,
            "price": receipt.price,
            "items": receipt.items?.map { ["id": $0.id, "name": $0.name, "price": $0.price] } ?? [],
            "people": receipt.people?.map { ["id": $0.id, "name": $0.name, "claims": $0.claims.map { ["id": $0.id, "name": $0.name, "price": $0.price] }] } ?? []
        ]

        receiptRef.setValue(receiptData) { error, _ in
            if let error = error {
                print("Error saving receipt: \(error.localizedDescription)")
                completion(false)
            } else {
                self.userViewModel.addReceiptToUser(userId: userId ?? "BAD7", receiptId: receiptId) { success in
                    if success {
                        self.receipt = receipt
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]) {
        
        // Get the current date
        let currentDate = Date()

        // Create a DateFormatter for the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Specify the format for the date
        let dateString = dateFormatter.string(from: currentDate)

        // Create a DateFormatter for the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss a" // Specify the format for the time
        let timeString = timeFormatter.string(from: currentDate)
        
        let id = self.getUser()
        
        let newReceipt = Receipt(
            userId: id ?? "BAD8",
            name: name,
            date: dateString,
            createdAt: timeString,
            tax: tax,
            price: price,
            items: items,
            people: people
        )
        self.receipt = newReceipt
        print("items IN newreceipt is: \(self.receipt.items)")
    }
    
    func setPeople() {
        self.people = self.receipt.people!
        
        if let currentUser = userViewModel.currentUser {
            let currentUserPerson = LegitP(id: dbRef.child("people").childByAutoId().key ?? "BAD5", name: currentUser.name)
            if !people.contains(where: { $0.name == currentUserPerson.name }) {
                people.append(currentUserPerson)
            }
        }

        // Assign a Firebase generated key to each person in the list if they do not already have one
        for index in people.indices {
            if people[index].id.isEmpty {
                people[index].id = dbRef.child("people").childByAutoId().key ?? "BAD6"
            }
        }

        // Ensure the receipt.people is populated
        self.receipt.people = self.people
    }

    func setItems() {
        self.items = self.receipt.items!
        
        // Assign a Firebase generated key to each item in the list, regardless of their current ID
        for index in items.indices {
            if items[index].id.isEmpty {
                items[index].id = dbRef.child("items").childByAutoId().key ?? "BAD7"
            }
        }

        // Ensure the receipt.items is populated
        self.receipt.items = self.items
    }
    
    func setReceipt(receipt: Receipt){
        // takes care of any discrepancies between the receipt value that resides in here and
        // the receipt variable in BillDetailsView
        self.receipt = receipt
    }

    func getUser() -> String? {
        return userViewModel.currentUser?.id
    }
    
    func personTotal() -> Double {
        var totalPrice: Double = 0.0
        
        if let claims = selectedPerson?.claims {
            for item in claims {
                totalPrice += item.price
            }
        }
        
        return totalPrice
    }
    
    func selectPerson(_ person: LegitP) {
        selectedPerson = person
        selectedItems = person.claims
    }
    
    func toggleItemSelection(_ item: Item) {
        guard let selectedP = selectedPerson else { return }

        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
            selectedPerson?.claims = selectedItems
        } else {
            selectedItems.append(item)
            selectedPerson?.claims = selectedItems
            print("selectedItems: \(selectedItems)")
        }
        updateClaims()
    }
    
    private func updateClaims() {
        guard let selectedPerson = selectedPerson else { return }
//        print("guard runs!")
//        if let index = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
//            receipt.people?[index].claims = selectedItems
//            print("people.claims: \(receipt.people?[index].claims ?? [Item(id: "default", name: "Default Item", price: 0.0)])")
//        }
        
        print("receipt.people: \(String(describing: receipt.people))")
        print("selectedPerson.id: \(selectedPerson.id)")

        if let index = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
            print("Found index: \(index)")
            receipt.people?[index].claims = selectedItems
            print("people.claims: \(receipt.people?[index].claims ?? [Item(id: "default", name: "Default Item", price: 0.0)])")
        } else {
            print("No matching person found in receipt.people")
        }
        
        objectWillChange.send()
    }
}

