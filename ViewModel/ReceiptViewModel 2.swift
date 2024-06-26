//
//  ReceiptViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//


import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Combine
import SwiftUI

class ReceiptViewModel: ObservableObject {
    @Published var receiptList: [Receipt] = []
    @Published var receipt: Receipt
    @Published var items: [Item] = []
    @Published var people: [LegitP] = []
    
    @Published var selectedPerson: LegitP?
    @Published var selectedItems: [Item] = []

    var userViewModel: UserViewModel
    
    private var dbRef = Database.database().reference()
    private var personColorMap: [String: Color] = [:]
    private let colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow, .pink, .gray]
    
    init(user: UserViewModel) {
        self.userViewModel = user
        self.receipt = Receipt()
    }
    
    func fetchUserReceipts() {
        guard let userID = userViewModel.currentUser?.id else {
            print("fetchUserReceipts: User not authenticated or user ID not available")
            return
        }
        
        self.receiptList = []

        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let userData = snapshot.value as? [String: Any],
                  let receiptIDs = userData["receipts"] as? [String] else {
                print("User data or receipts not found")
                return
            }
            self.fetchReceipts(receiptIDs: receiptIDs)
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
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
                    var receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    if !fetchedReceipts.contains(where: { $0.id == receipt.id }) {
                        self.assignColorsToPeople(in: &receipt)
                        fetchedReceipts.append(receipt)
                    }
                } catch {
                    print("Error decoding receipt: \(error.localizedDescription)")
                }
            })
        }

        group.notify(queue: .main) {
            self.receiptList = fetchedReceipts
            print("All receipts fetched: \(self.receiptList)")
            self.setupReceiptListeners(receiptIDs: receiptIDs)
        }
    }
    
    private func setupReceiptListeners(receiptIDs: [String]) {
        for receiptID in receiptIDs {
            dbRef.child("receipts").child(receiptID).observe(.value, with: { [weak self] snapshot in
                print("Receipt data snapshot: \(snapshot)")

                guard snapshot.exists() else {
                    print("Snapshot does not exist.")
                    return
                }

                guard let value = snapshot.value as? [String: Any] else {
                    print("Snapshot does not contain a valid dictionary. Snapshot value: \(snapshot.value ?? "nil")")
                    return
                }

                print("Receipt data snapshot value: \(value)")

                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    self?.updateReceiptInList(receipt)
                } catch let error {
                    print("Error decoding receipt: \(error.localizedDescription)")
                }
            }) { error in
                print("Error fetching receipt data: \(error.localizedDescription)")
            }
        }
    }
    
    //Function for adding a receipt to a users list of receipts based on the receipt value "userid"
    //should probably make this PRIVATE
    
    func addReceiptToUser2(receiptId: String, completion: @escaping (Bool) -> Void){
        let userReceiptsRef = dbRef.child("users").child(receipt.userId).child("receipts")
        
        // Retrieve current receipts to append the new one
        userReceiptsRef.observeSingleEvent(of: .value, with: { snapshot in
            var receipts: [String]
            if let existingReceipts = snapshot.value as? [String] {
                receipts = existingReceipts
            } else {
                receipts = []
            }
        
            // Check if the receipt ID already exists in the user's receipts
            if receipts.contains(receiptId) {
                print("Receipt ID \(receiptId) already exists for user \(self.receipt.userId)")
                completion(true)
                return
            }
        
            // Append the new receipt ID
            receipts.append(receiptId)
            print("Appending receipt ID: \(receiptId) to user ID: \(self.receipt.userId)")
        
            // Update the user's receipts in Firebase
            userReceiptsRef.setValue(receipts) { error, _ in
                if let error = error {
                    print("Error updating user receipts: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User receipts updated successfully.")
                    completion(true)
                }
            }
        }) { error in
            print("Error retrieving user receipts: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func updateReceiptInList(_ receipt: Receipt) {
        if let index = self.receiptList.firstIndex(where: { $0.id == receipt.id }) {
            self.receiptList[index] = receipt
        } else {
            self.receiptList.append(receipt)
        }
        self.objectWillChange.send()
    }
    
    func saveReceipt(completion: @escaping (Bool) -> Void) {

        if receipt.id.isEmpty {
            receipt.id = dbRef.child("receipts").childByAutoId().key ?? ""
            print("Generated new receipt ID: \(receipt.id)")
        }

        print("Saving receipt with ID: \(receipt.id)")
        
        let receiptData: [String: Any] = [
            "id": receipt.id,
            "userId": receipt.userId,
            "name": receipt.name,
            "date": receipt.date,
            "createdAt": receipt.createdAt,
            "tax": receipt.tax,
            "price": receipt.price,
            "items": receipt.items?.map { item in
                ["id": item.id, "name": item.name, "price": item.price]
            } ?? [],
            "people": receipt.people?.map { person in
                [
                    "id": person.id,
                    "name": person.name,
                    "claims": person.claims.map { item in
                        ["id": item.id, "name": item.name, "price": item.price]
                    }
                ]
            } ?? []
        ]

        print("Receipt data to save: \(receiptData)")

        dbRef.child("receipts").child(receipt.id).setValue(receiptData) { error, _ in
            if let error = error {
                print("Error saving receipt: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Receipt saved successfully. Adding receipt ID to user.")
                self.addReceiptToUser2(receiptId: self.receipt.id) { success in
                    if success {
                        print("Receipt ID added to user successfully.")
                        completion(true)
                    } else {
                        print("Failed to add receipt ID to user.")
                        completion(false)
                    }
                }
            }
        }
    }

    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]) {
        let currentDate = Date()
        print("Current date: \(currentDate)")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        print("Formatted date: \(dateString)")

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss a"
        let timeString = timeFormatter.string(from: currentDate)
        print("Formatted time: \(timeString)")

        let id = self.getUser()
        print("User ID: \(id ?? "No User ID")")

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

        if let items = self.receipt.items {
            print("Items in new receipt:")
            for item in items {
                print(item)
            }
        } else {
            print("No items in new receipt")
        }

        if let people = self.receipt.people {
            print("People in new receipt:")
            for person in people {
                print(person)
            }
        } else {
            print("No people in new receipt")
        }
        
        print("New receipt created with ID: \(self.receipt.id)")
    }
    
    func setReceipt(receipt: Receipt) {
        self.receipt = receipt
    }
    
    private func assignColorsToPeople(in receipt: inout Receipt) {
        for (index, person) in receipt.people?.enumerated() ?? [].enumerated() {
            if personColorMap[person.id] == nil {
                personColorMap[person.id] = colors[index % colors.count]
            }
        }
    }
    
    func colorForPerson(_ person: LegitP) -> Color {
        return personColorMap[person.id] ?? .green
    }
    
    func setPeople() {
        print("Setting people from receipt...")
        guard let receiptPeople = self.receipt.people else {
            print("Error: Receipt has no people.")
            return
        }

        self.people = receiptPeople
        print("Initial people set from receipt: \(self.people)")

        if let currentUser = userViewModel.currentUser {
            let currentUserPerson = LegitP(id: dbRef.child("people").childByAutoId().key ?? "BAD5", name: currentUser.name)
            print("Current user person: \(currentUserPerson)")

            if !people.contains(where: { $0.name == currentUserPerson.name }) {
                people.append(currentUserPerson)
                print("Added current user to people: \(currentUserPerson)")
            }
        }

        for index in people.indices {
            if people[index].id.isEmpty {
                let newId = dbRef.child("people").childByAutoId().key ?? "BAD6"
                people[index].id = newId
                print("Assigned new ID to person at index \(index): \(people[index])")
            }
        }

        self.receipt.people = self.people
        print("Final people in receipt: \(self.receipt.people ?? [])")
    }

    func setItems() {
        print("Setting items from receipt...")
        guard let receiptItems = self.receipt.items else {
            print("Error: Receipt has no items.")
            return
        }

        self.items = receiptItems
        print("Initial items set from receipt: \(self.items)")

        for index in items.indices {
            if items[index].id.isEmpty {
                let newId = dbRef.child("items").childByAutoId().key ?? "BAD7"
                items[index].id = newId
                print("Assigned new ID to item at index \(index): \(items[index])")
            }
        }

        self.receipt.items = self.items
        print("Final items in receipt: \(self.receipt.items ?? [])")
    }

    func getUser() -> String? {
        return userViewModel.currentUser?.id
    }
    
    func selectPerson(_ person: LegitP) {
        selectedPerson = person
        selectedItems = person.claims
    }
    
    func toggleItemSelection(_ item: Item) {
        //if index
        
        print("toggleItemSelection runs!")
        guard let selectedPerson = selectedPerson else { return }

        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
            // need to add code to update items' claimedBy property
        } else {
            print("appending item: \(item)")
            selectedItems.append(item)
            // need to add code to add person to items claimedBy
        }

        if let personIndex = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
            receipt.people?[personIndex].claims = selectedItems
            print("calling saveReceipt")
            saveReceipt { success in
                if success {
                    print("Receipt saved successfully.")
                } else {
                    print("Failed to save the receipt.")
                }
            }
        }

        objectWillChange.send()
    }
    
//    func claimsTest() {
//        guard receipt.people?.count ?? 0 > 1 else {
//            print("Not enough people to perform the test.")
//            return
//        }
//
//        // Generate a new ID from Firebase
//        let newItemRef = dbRef.child("items").childByAutoId()
//        let newItemID = newItemRef.key ?? "BAD-3"
//
//        // Create a new fake claim with the generated ID
//        let newClaim = Item(id: newItemID, name: "Test Item", price: 9.99)
//
//        // Add the new claim to the second person in the people list
//        receipt.people?[1].claims.append(newClaim)
//
//        // Save the new item to Firebase
//        let itemData: [String: Any] = ["id": newClaim.id, "name": newClaim.name, "price": newClaim.price]
//        newItemRef.setValue(itemData) { error, _ in
//            if let error = error {
//                print("Error saving new item: \(error.localizedDescription)")
//                return
//            }
//
//            // Update the receipt in Firebase to trigger real-time updates
//            self.saveReceipt { success in
//                if success {
//                    print("Test claim added successfully and receipt updated.")
//                } else {
//                    print("Failed to update the receipt with the test claim.")
//                }
//            }
//        }
//    }

    func personTotal(for person: LegitP) -> Double {
        return person.claims.reduce(0) { $0 + $1.price }
    }
    
    // Function to check if an item is claimed by another person
    func isItemClaimedByAnotherPerson(_ item: Item) -> Bool {
        guard let selectedPerson = selectedPerson else { return false }
        return receipt.people?.contains { person in
            person.id != selectedPerson.id && person.claims.contains(where: { $0.id == item.id })
        } ?? false
    }
    
    // Function to check if a person has any claims
    func personHasClaims(_ person: LegitP) -> Bool {
        return !person.claims.isEmpty
    }
    
    // Function to fetch a receipt given a receiptId from the user in the join bill view
    func joinReceiptWith(receiptId: String, completion: @escaping (Bool) -> Void) {
        dbRef.child("receipts").child(receiptId).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                print("Snapshot does not exist for receiptId: \(receiptId)")
                completion(false)
                return
            }
            
            guard let value = snapshot.value as? [String: Any] else {
                print("Snapshot does not contain a valid dictionary. Snapshot value: \(snapshot.value ?? "nil")")
                completion(false)
                return
            }
            
            print("Receipt data snapshot value: \(value)")
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                self.receipt = receipt
                completion(true)
            } catch let error {
                print("Error decoding receipt: \(error.localizedDescription)")
                completion(false)
            }
        }) { error in
            print("Error fetching receipt data: \(error.localizedDescription)")
            completion(false)
        }
    }
}