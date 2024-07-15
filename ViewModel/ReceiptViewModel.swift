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
    @Published var selectedItemsIds: [String] = []

    var userViewModel: UserViewModel
    
    private var dbRef = Database.database().reference()
    
    init(user: UserViewModel) {
        self.userViewModel = user
        self.receipt = Receipt()
    }
    
    //main actor cuz updates can't be published from a background thread
    @MainActor
    func fetchUserReceipts() async {
        guard let userID = userViewModel.currentUser?.id else {
            print("fetchUserReceipts: User not authenticated or user ID not available")
            return
        }
        
        self.receiptList = []

        dbRef.child("users").child(userID).observe(.value, with: { snapshot in
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
    
//================================================================================================
        //Listeners Section
//================================================================================================
    
    private func setupReceiptListeners(receiptIDs: [String]) {
        for receiptID in receiptIDs {
            dbRef.child("receipts").child(receiptID).observe(.value, with: { [weak self] snapshot in
                //print("Receipt data snapshot: \(snapshot)")

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
                    print("do block runs!")
                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    //print("data is: \(data)")
                    print("receipt variable is: \(receipt.name)")
                    
                    //self?.receipt = receipt
                    self?.updateReceiptInList(receipt)
                } catch let error {
                    print("Error decoding receipt: \(error.localizedDescription)")
                }
            }) { error in
                print("Error fetching receipt data: \(error.localizedDescription)")
            }

            let receiptRef = dbRef.child("receipts").child(receiptID)
            self.setupPeopleListeners(receiptRef, receiptID: receiptID)
            self.setupItemListeners(receiptRef, receiptID: receiptID)
            
        }
    }
    
    //People Listeners
    private func setupPeopleListeners(_ receiptRef: DatabaseReference, receiptID: String) {
        let peopleRef = receiptRef.child("people")
        peopleRef.observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self, snapshot.exists(),
                  let peopleArray = snapshot.value as? [[String: Any]] else {
                print("People data snapshot does not exist or is not a valid array.")
                return
            }

            strongSelf.handlePeopleUpdate(peopleArray, forReceipt: receiptID)

        }) { error in
            print("Error fetching people data: \(error.localizedDescription)")
        }
    }
    
    private func handlePeopleUpdate(_ peopleData: [[String: Any]], forReceipt receiptID: String) {
        do {
            let data = try JSONSerialization.data(withJSONObject: peopleData, options: [])
            let people = try JSONDecoder().decode([LegitP].self, from: data)
            print("Updated people list for receipt \(receiptID): \(people)")
            updatePeopleInReceipt(receiptID, with: people)
        } catch let error {
            print("Error decoding people: \(error)")
        }
    }

    private func updatePeopleInReceipt(_ receiptID: String, with people: [LegitP]) {
        if let index = receiptList.firstIndex(where: { $0.id == receiptID }) {
            receiptList[index].people = people
            objectWillChange.send()
        }
    }
    
    //Items Listeners
    private func setupItemListeners(_ receiptRef: DatabaseReference, receiptID: String) {
        let itemsRef = receiptRef.child("items")
        itemsRef.observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self, snapshot.exists(),
                  let itemsArray = snapshot.value as? [[String: Any]] else {
                print("Items data snapshot does not exist or is not a valid array.")
                return
            }

            // Handle items data update
            strongSelf.handleItemsUpdate(itemsArray, forReceipt: receiptID)
        }) { error in
            print("Error fetching items data: \(error.localizedDescription)")
        }
    }

    private func handleItemsUpdate(_ itemsData: [[String: Any]], forReceipt receiptID: String) {
        do {
            let data = try JSONSerialization.data(withJSONObject: itemsData, options: [])
            let items = try JSONDecoder().decode([Item].self, from: data)
            print("Updated items list for receipt \(receiptID): \(items)")
            updateItemsInReceipt(receiptID, with: items)
        } catch let error {
            print("Error decoding items: \(error)")
        }
    }

    private func updateItemsInReceipt(_ receiptID: String, with items: [Item]) {
        if let index = receiptList.firstIndex(where: { $0.id == receiptID }) {
            receiptList[index].items = items
            objectWillChange.send()
        }
    }

//================================================================================================
            // END Listeners Section
//================================================================================================
    
    
//Function for adding a receipt to a users list of receipts based on the receipt value "userid"
//should probably make this PRIVATE
    func addReceiptToUser2(receiptId: String, completion: @escaping (Bool) -> Void){
        let userReceiptsRef = dbRef.child("users").child(userViewModel.currentUser!.id).child("receipts")
        
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
        print("updates receipt is: \(receipt)")
        if let index = self.receiptList.firstIndex(where: { $0.id == receipt.id }) {
            self.receiptList[index] = receipt
            self.receipt = receipt
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
            "tip": receipt.tip,
            "items": receipt.items?.map { item in
                ["id": item.id, "name": item.name, "price": item.price]
            } ?? [],
            "people": receipt.people?.map { $0.toDict() } ?? []
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

    func newReceipt(name: String, tax: Double, tip: Double, price: Double, items: [Item], people: [LegitP]) {
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
            tip: tip,
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
    
    func addUserToItem() {
        
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
        selectedItemsIds = person.claims
    }
    
    func toggleItemSelection(_ item: Item) {
        //if index
        
        print("toggleItemSelection runs!")
        guard let selectedPerson = selectedPerson else { return }

        if let index = selectedItemsIds.firstIndex(of: item.id) {
            selectedItemsIds.remove(at: index)
            // need to add code to update items' claimedBy property
        } else {
            print("appending item: \(item)")
            selectedItemsIds.append(item.id)
            // need to add code to add person to items claimedBy
        }

        if let personIndex = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
            receipt.people?[personIndex].claims = selectedItemsIds
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

    // Function to check if an item is claimed by another person
    func isItemClaimedByAnotherPerson(_ item: Item) -> Bool {
        guard let selectedPerson = selectedPerson else { return false }
        return receipt.people?.contains { person in
            person.id != selectedPerson.id && person.claims.contains(where: { $0 == item.id })
        } ?? false
    }

    // Function to check if a person has any claims
    func personHasClaims(_ person: LegitP) -> Bool {
        return !person.claims.isEmpty
    }
    
    // Function to fetch a receipt given a receiptId from the user in the join bill view
    func joinReceiptWith(receiptId: String, completion: @escaping (Bool) -> Void) {
        if (receiptId.isEmpty) {
            print("receiptId is Empty")
            return
        }
        
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

    // Check if the item is claimed by another person
    func isItemClaimedByOther(_ item: Item) -> LegitP? {
        guard let people = receipt.people, let selectedPersonId = selectedPerson?.id else {
            return nil
        }

        return people.first { person in
            person.id != selectedPersonId && person.claims.contains(item.id)
        }
    }
}

