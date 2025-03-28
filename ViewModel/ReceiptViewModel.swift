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

@MainActor
class ReceiptViewModel: ObservableObject {
    @Published var receiptList: [Receipt] = []
    @Published var receipt: Receipt
    @Published var items: [Item] = []
    @Published var people: [LegitP] = []
    @Published var selectedPerson: LegitP?
    @Published var selectedItemsIds: [String] = []
    @Published private(set) var listenersSetUp = false
    var userID: String?
    @Published private(set) var isLoaded = false
    @Published var hasAttemptedFetch: Bool = false
    
    private var dbRef = Database.database().reference()
    private var cancellables = Set<AnyCancellable>()
    
    var totalAmountOwed: Decimal {
        let total = receiptList.reduce(Decimal.zero) { total, receipt in
            let stillOwed = receipt.calculateStillOwed()
            return total + stillOwed
        }
        return total
    }
    
    var openChecksCount: Int {
        let threshold = Decimal(string: "0.01")!
        
        let openChecks = receiptList.filter { receipt in
            let stillOwed = receipt.calculateStillOwed()
            print("Receipt ID: \(receipt.id), Still owed: \(stillOwed)")
            return stillOwed > threshold
        }
        
        let count = openChecks.count
        print("Open checks count: \(count)")
        return count
    }
    
    init() {
        self.receipt = Receipt()
        self.userID = User.getUserdId() ?? "VERY BAD"
        print("RVM initialized with user id: \(userID)\n")

        Task {
            await fetchUserReceipts()
            DispatchQueue.main.async {
                self.isLoaded = true
            }
        }
    }
    
    func fetchUserReceipts() async {
        guard let userID = userID else {
            print("fetchUserReceipts: User not authenticated or user ID not available")
            return
        }
        
        do {
            let snapshot = try await dbRef.child("users").child(userID).getData()
            guard let userData = snapshot.value as? [String: Any],
                  let receiptIDs = userData["receipts"] as? [String] else {
                print("User data or receipts not found")
                return
            }
            await fetchReceipts(receiptIDs: receiptIDs)
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    func fetchReceipts(receiptIDs: [String]) async {
        var fetchedReceipts: [Receipt] = []

        for receiptID in receiptIDs {
            do {
                let snapshot = try await dbRef.child("receipts").child(receiptID).getData()
                guard let receiptData = snapshot.value as? [String: Any] else {
                    print("Receipt data not found for ID: \(receiptID)")
                    continue
                }
                //print("Receipt data snapshot value for \(receiptID): \(receiptData)")
                let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
                let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                if !fetchedReceipts.contains(where: { $0.id == receipt.id }) {
                    fetchedReceipts.append(receipt)
                }
            } catch {
                print("Error decoding receipt: \(error.localizedDescription)")
            }
        }

        await MainActor.run {
            self.receiptList = fetchedReceipts
            self.hasAttemptedFetch = true
        }
        self.receiptList = fetchedReceipts
        //print("All receipts fetched: \(self.receiptList)")
        
        if !listenersSetUp {
            setupReceiptListeners(receiptIDs: receiptIDs)
        } else {
            print("Listeners already set up, skipping setup")
        }
    }
    
    func getReceipt(id: String) async -> Receipt? {
        reset()
        do {
            let snapshot = try await dbRef.child("receipts").child(id).getData()
            
            guard let value = snapshot.value as? [String: Any] else {
                print("Receipt data not found for ID: \(id)")
                return nil
            }
            
            //print("Receipt data snapshot value: \(value)")
            
            let data = try JSONSerialization.data(withJSONObject: value)
            let loadedReceipt = try JSONDecoder().decode(Receipt.self, from: data)
            
            self.receipt = loadedReceipt
            //print("Receipt loaded: \(loadedReceipt.name)")
            
            // Temp variables to match what the methods need
            let tempReceiptList = [id]
            let receiptRef = dbRef.child("receipts").child(id)
            // Set up listeners for real-time updates
            setupReceiptListeners(receiptIDs: tempReceiptList)
            setupPeopleListeners(receiptRef, receiptID: id)
            setupItemListeners(receiptRef, receiptID: id)
            
            return self.receipt
        } catch {
            print("Error loading receipt: \(error.localizedDescription)")
            return nil
        }
    }
    
    func handleEdit() {
        print("Edit button was tapped")
    }
    
    func reset() {
        self.receipt = Receipt()
    }
    
    
    //url builder function
    func shareCheck(receiptId: String) {
        // Create a web URL for your app
        let webURLString = "https://www.fatcheck.app/receipt/\(receiptId)"
        guard let url = URL(string: webURLString) else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )
        
        // Present the view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func updatePersonPaidStatus(personId: String, isPaid: Bool) {
        if let index = receipt.people?.firstIndex(where: { $0.id == personId }) {
            receipt.people?[index].paid = isPaid
            saveReceipt { success in
                if success {
                    print("Receipt saved successfully after updating paid status")
                } else {
                    print("Failed to save receipt after updating paid status")
                }
            }
        }
    }
    
    func updateTip(_ newTip: Decimal) {
        receipt.tip = newTip
        // Add any additional logic here, such as updating the backend or recalculating totals
        saveReceipt() { success in
            if success {
                print("good")
            } else {
                print("bad")
            }
        }
    }
    
    func updateTax(_ newTax: Decimal) {
        receipt.tax = newTax
        // Add any additional logic here, such as updating the backend or recalculating totals
        saveReceipt() { success in
            if success {
                print("good")
            } else {
                print("bad")
            }
        }
    }
    
//================================================================================================
        //Listeners Section
//================================================================================================
    
    func setupReceiptListeners(receiptIDs: [String]) {
        guard !listenersSetUp else { return }
        
        //print("setting up listeners for receipts: \(receiptIDs)\n")
        
        for receiptID in receiptIDs {
            //print("setting up listener for id: \(receiptID)\n")
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

                //print("Receipt data snapshot value: \(value)")

                do {
                    //print("do block runs!")
                    let data = try JSONSerialization.data(withJSONObject: value, options: [])
                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
                    //print("data is: \(data)")
                    //print("receipt variable is: \(receipt.name)")
                    
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
        
        listenersSetUp = true
        print("Finished setting up all listeners")
    }
    
    //People Listeners
    func setupPeopleListeners(_ receiptRef: DatabaseReference, receiptID: String) {
        //print("setting up people listners for id: \(receiptID)")
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
    
    func handlePeopleUpdate(_ peopleData: [[String: Any]], forReceipt receiptID: String) {
        do {
            let data = try JSONSerialization.data(withJSONObject: peopleData, options: [])
            let people = try JSONDecoder().decode([LegitP].self, from: data)
            //print("Updated people list for receipt \(receiptID): \(people)")
            updatePeopleInReceipt(receiptID, with: people)
        } catch let error {
            print("Error decoding people: \(error)")
        }
    }

    func updatePeopleInReceipt(_ receiptID: String, with people: [LegitP]) {
        print("people updating...")
        if let index = receiptList.firstIndex(where: { $0.id == receiptID }) {
            receiptList[index].people = people
            objectWillChange.send()
        }
    }
    
    //Items Listeners
    func setupItemListeners(_ receiptRef: DatabaseReference, receiptID: String) {
        //print("setting up item listeners for id: \(receiptID)")
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

    func handleItemsUpdate(_ itemsData: [[String: Any]], forReceipt receiptID: String) {
        do {
            let data = try JSONSerialization.data(withJSONObject: itemsData, options: [])
            let items = try JSONDecoder().decode([Item].self, from: data)
            //print("Updated items list for receipt \(receiptID): \(items)")
            updateItemsInReceipt(receiptID, with: items)
        } catch let error {
            print("Error decoding items: \(error)")
        }
    }

    func updateItemsInReceipt(_ receiptID: String, with items: [Item]) {
        print("items updating...")
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
        let userReceiptsRef = dbRef.child("users").child(userID ?? "").child("receipts")
        
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
            //print("Appending receipt ID: \(receiptId) to user ID: \(self.receipt.userId)")
        
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
    
    func updateReceiptInList(_ receipt: Receipt) {
        //print("updates receipt is: \(receipt)")
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
            //print("Generated new receipt ID: \(receipt.id)")
        }

        //print("Saving receipt with ID: \(receipt.id)")
        
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

        //print("Receipt data to save: \(receiptData)")

        dbRef.child("receipts").child(receipt.id).setValue(receiptData) { error, _ in
            if let error = error {
                print("Error saving receipt: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Receipt saved successfully")
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

    func newReceipt(name: String, tax: Decimal, tip: Decimal, price: Decimal, items: [Item], people: [LegitP]) {
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
    
//=======================================
    
    func deleteReceipt(at offsets: IndexSet) {
        guard let index = offsets.first, index < receiptList.count else { return }
        let receiptToDelete = receiptList[index]
        
        print("Attempting to delete receipt with ID: \(receiptToDelete.id)")
        
        deleteReceiptFromReceiptNode(receiptId: receiptToDelete.id) { [weak self] success in
            if success {
                print("Successfully deleted receipt from receipt node")
                self?.removeReceiptFromUserList(receiptId: receiptToDelete.id) { success in
                    DispatchQueue.main.async {
                        if success {
                            self?.receiptList.remove(at: index)
                            print("Successfully removed receipt from user's list")
                        } else {
                            print("Failed to remove receipt from user's list")
                        }
                    }
                }
            } else {
                print("Failed to delete receipt from receipt node")
            }
        }
    }
    
    private func deleteReceiptFromReceiptNode(receiptId: String, completion: @escaping (Bool) -> Void) {
        let receiptRef = dbRef.child("receipts").child(receiptId)
        receiptRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting receipt from node: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Receipt successfully deleted from node")
                completion(true)
            }
        }
    }
    
    private func removeReceiptFromUserList(receiptId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No current user ID")
            completion(false)
            return
        }
        
        print("Attempting to remove receipt \(receiptId) for user \(userId)")
        
        let userReceiptsRef = dbRef.child("users").child(userId).child("receipts")
        
        userReceiptsRef.observeSingleEvent(of: .value) { snapshot in
            print("User receipts snapshot: \(snapshot.value ?? "nil")")
            
            guard var receipts = snapshot.value as? [String] else {
                print("Error: Couldn't cast receipts to [String]")
                completion(false)
                return
            }
            
            print("Current receipts: \(receipts)")
            
            // Remove the receipt ID from the local copy
            let originalCount = receipts.count
            receipts.removeAll { $0 == receiptId }
            let newCount = receipts.count
            
            print("Receipts after filtering: \(receipts)")
            print("Removed \(originalCount - newCount) receipt(s)")
            
            if receipts.isEmpty {
                // If the receipts list is now empty, remove the entire "receipts" node
                userReceiptsRef.removeValue { error, _ in
                    if let error = error {
                        print("Error removing receipts node: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully removed empty receipts node")
                        completion(true)
                    }
                }
            } else {
                // Otherwise, update the receipts list
                userReceiptsRef.setValue(receipts) { error, _ in
                    if let error = error {
                        print("Error updating receipts: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully updated receipts")
                        completion(true)
                    }
                }
            }
        }
    }
    
//=======================================
    
    func setReceipt(receiptId: String) {
        Task {
            if let fetchedReceipt = await self.getReceipt(id: receiptId) {
                self.receipt = fetchedReceipt
            } else {
                self.receipt = Receipt() // Or handle the error appropriately
            }
        }
    }
    
    func setPeople() {
        print("Setting people from receipt...")
        guard let receiptPeople = self.receipt.people else {
            print("Error: Receipt has no people.")
            return
        }

        self.people = receiptPeople
        print("Initial people set from receipt: \(self.people)")

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
        return userID
    }
    
    func updateReceipt() {
        // After making any changes to the receipt or its contents
        objectWillChange.send()
        self.receipt = self.receipt // This triggers the @Published property wrapper
    }
    
    func selectPerson(_ person: LegitP) {
        
        if person.id == selectedPerson?.id {
            selectedPerson = nil
            selectedItemsIds = [""]
        } else {
            selectedPerson = person
            selectedItemsIds = person.claims
        }
        
    }
    
    func toggleItemSelection(_ item: Item) {
        //if index
        
        print("items have been toggled")
        guard let selectedPerson = selectedPerson else { return }

        if let index = selectedItemsIds.firstIndex(of: item.id) {
            print("removing item: \(item)")
            selectedItemsIds.remove(at: index)
        } else {
            print("appending item: \(item)")
            selectedItemsIds.append(item.id)
        }

        if let personIndex = receipt.people?.firstIndex(where: { $0.id == selectedPerson.id }) {
            receipt.people?[personIndex].claims = selectedItemsIds
            //print("calling saveReceipt")
            saveReceipt { success in
                if success {
                    print("toggleItems: Receipt saved successfully.")
                } else {
                    print("toggleItems: Failed to save the receipt.")
                }
            }
        }

        updateReceipt()
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
    
    func addItem(newItem: Item) {
        newItem.id = self.createItemId(receiptId: receipt.id)
        self.receipt.items?.append(newItem)
        objectWillChange.send()
    }
    func createItemId(receiptId: String) -> String {
        return dbRef.child("receipts").child(receiptId).child("items").childByAutoId().key ?? ""
    }
    
    func createPersonId(receiptId: String) -> String {
        return dbRef.child("receipts").child(receiptId).child("persons").childByAutoId().key ?? ""
    }
    
    func addPerson(newPerson: LegitP) {
        newPerson.id = self.createPersonId(receiptId: receipt.id)
        self.receipt.people?.append(newPerson)
        objectWillChange.send()
    }
    
    func updatePerson(personId: String, editedName: String) {
        if let index = receipt.people?.firstIndex(where: { $0.id == personId }) {
            receipt.people?[index].name = editedName
            objectWillChange.send()
        }
    }
    
    func getRandomColor() -> Color {
        let allColors: [Color] = [.red, .blue, .green, .orange, .yellow, .gray, .purple, .pink, .teal, .black, .mint, .cyan, .indigo]
        
        let usedColors = Set(self.receipt.people?.map { $0.color } ?? [])

        var availableColors = allColors.filter { !usedColors.contains($0) }
        
        if availableColors.isEmpty {
            availableColors = allColors
        }
        
        let randomIndex = Int.random(in: 0..<availableColors.count)
        return availableColors[randomIndex]
    }
}

