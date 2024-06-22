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

class ReceiptViewModel: ObservableObject {
    @Published var receiptList: [Receipt] = []
    @Published var receipt: Receipt
    @Published var items: [Item] = []
    @Published var people: [LegitP] = []
    
    @Published var selectedPerson: LegitP?
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
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    if !fetchedReceipts.contains(where: { $0.id == receipt.id }) {
                        fetchedReceipts.append(receipt)
                    }
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
