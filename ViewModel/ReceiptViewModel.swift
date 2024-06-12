//
//  ReceiptViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Combine

class ReceiptViewModel: ObservableObject {
    @Published var receiptList: [Receipt] = []
    @Published var receipt: Receipt
    @Published var items: [Item] = []
    @Published var people: [LegitP] = []
    
    // variable to keep track of user selecting their name on the BillDetailsView
    @Published var selectedPerson: LegitP?
    
    // variable that keeps track of user claiming/selecting items before they are saved to the database
    @Published var selectedItems: [Item] = []

    var userViewModel: UserViewModel
    
    private var dbRef = Database.database().reference()
    
    init(user: UserViewModel) {
        self.userViewModel = user
        self.receipt = Receipt()
    }
    
    func fetchUserReceipts() {
        guard let userID = userViewModel.currentUser?.id else {
            print("fetchUserReceipts: User not authenticated or user ID not available")
            return
        }

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
                self.userViewModel.addReceiptToUser(userId: self.receipt.userId, receiptId: self.receipt.id) { success in
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
    
    private func savePeople(_ people: [LegitP]) {
        guard !receipt.id.isEmpty else { return }
        let peopleData = people.map { ["id": $0.id, "name": $0.name, "claims": $0.claims.map { ["id": $0.id, "name": $0.name, "price": $0.price] }] }
        
        dbRef.child("receipts").child(receipt.id).child("people").setValue(peopleData) { error, _ in
            if let error = error {
                print("Error saving people: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveItems(_ items: [Item]) {
        guard !receipt.id.isEmpty else { return }
        let itemsData = items.map { ["id": $0.id, "name": $0.name, "price": $0.price] }
        
        dbRef.child("receipts").child(receipt.id).child("items").setValue(itemsData) { error, _ in
            if let error = error {
                print("Error saving items: \(error.localizedDescription)")
            }
        }
    }
    
    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]) {
        // Get the current date
        let currentDate = Date()
        print("Current date: \(currentDate)")

        // Create a DateFormatter for the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: currentDate)
        print("Formatted date: \(dateString)")

        // Create a DateFormatter for the time
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm:ss a"
        let timeString = timeFormatter.string(from: currentDate)
        print("Formatted time: \(timeString)")

        // Get the user ID
        let id = self.getUser()
        print("User ID: \(id ?? "No User ID")")

        // Create a new receipt
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

        // Debug print the items in the new receipt
        if let items = self.receipt.items {
            print("Items in new receipt:")
            for item in items {
                print(item)
            }
        } else {
            print("No items in new receipt")
        }

        // Debug print the people in the new receipt
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
        guard let selectedPerson = selectedPerson else { return }

        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }

        if let personIndex = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
            receipt.people?[personIndex].claims = selectedItems
        }

        objectWillChange.send()
    }

    func personTotal(for person: LegitP) -> Double {
        return person.claims.reduce(0) { $0 + $1.price }
    }
    
    func setupReceiptListener(receiptID: String) {
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
                print("Decoded receipt: \(receipt)")
                self?.receipt = receipt
            } catch let error {
                print("Error decoding receipt: \(error.localizedDescription)")
            }
        }) { error in
            print("Error fetching receipt data: \(error.localizedDescription)")
        }
    }
}


