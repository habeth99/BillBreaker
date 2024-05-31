//
//  ReceiptViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

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

//                do {
//                    let data = try JSONSerialization.data(withJSONObject: receiptData, options: [])
//                    let receipt = try JSONDecoder().decode(Receipt.self, from: data)
//                    fetchedReceipts.append(receipt)
//                } catch let error {
//                    print("Error decoding receipt: \(error.localizedDescription)")
//                }
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
            "people": receipt.people?.map { ["id": $0.id, "name": $0.name] } ?? []
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

    func getUser() -> String? {
        return userViewModel.currentUser?.id
    }
    
    func updateReceipt() {
        // TODO
    }
    
    func addPersonReceipt() {
        // TODO
    }
    
    func addItemReceipt() {
        // TODO
    }
    
    func deleteReceipt() {
        // TODO
    }
}


//import Foundation
//import FirebaseDatabase
//import FirebaseAuth
//import Firebase
//import FirebaseFirestoreSwift
//
//class ReceiptViewModel: ObservableObject {
//    @Published var receipt: Receipt
//    //@Published var user: UserViewModel
//    @Published var item: ItemViewModel
//    @Published var people: PersonViewModel
//    
//    // could be BAD but making user an environment variable
//    var userViewModel: UserViewModel
//    
//    private var dbRef = Database.database().reference()
//    
//    init(//receipt: Receipt,
//         user: UserViewModel) {
//        self.userViewModel = user
//        self.receipt = Receipt()
//        // Load or observe changes based on the user
//        //loadReceiptsForUser()
//    }
//    
////    init(receipt: Receipt, userViewModel: UserViewModel) {
////        
////        self.receipt = receipt
////        self.user = userViewModel
////        
////    }
//    
//    func getUserReceipts(){
//        //TODO
//    }
//    
//    func getReceipt(){
//        // TODO
//        // should return the info for one receipt that is tied to the current user
//        // probably one receipt object
//        
//        // return receipt
//    }
//    
////    //function to write a receipt and make sure its added to the current user
////    func saveReceipt(completion: @escaping (Bool) -> Void) {
////        let userId = self.getUser()
////        
////        print("Saving with items: \(receipt.items ?? [])")
////        print("Saving with people: \(receipt.people ?? [])")
////        
////        let receiptRef = dbRef.child("receipts").child(userId).childByAutoId()
////        let receiptId = receiptRef.key ?? ""
////        let receiptData: [String: Any] = [
////            "id": receipt.id,
////            "userId": receipt.userId,
////            "name": receipt.name,
////            "date": receipt.date,
////            "createdAt": receipt.createdAt,
////            "tax": receipt.tax,
////            "price": receipt.price,
////            "items": receipt.items?.map { ["id": $0.id, "name": $0.name, "price": $0.price] } ?? [],
////            "people": receipt.people?.map { ["id": $0.id, "name": $0.name] } ?? []
////        ]
////
////        // Write receipt data to Firebase
////        receiptRef.setValue(receiptData) { error, _ in
////            if let error = error {
////                print("Error saving receipt: \(error.localizedDescription)")
////                completion(false)
////            } else {
////                // If the receipt is saved successfully, update the user's receipts
////                self.userViewModel.addReceiptToUser(userId: userId, receiptId: receiptId, completion: completion)
////            }
////        }
////    }
//    
//    func saveReceipt(completion: @escaping (Bool) -> Void) {
//        // Ensure that the receipt property is not nil before proceeding
//        // No need to guard as receipt is non-optional
//        var receipt = self.receipt
//        
//        let userId = self.getUser()
//        
//        print("Saving with items: \(receipt.items ?? [])")
//        print("Saving with people: \(receipt.people ?? [])")
//        
//        let receiptRef = dbRef.child("receipts").childByAutoId()
//        
//        
//        let receiptId = receiptRef.key ?? ""
//        print("receiptId is: \(receiptId)")
//        
//        // Update the receipt ID before saving
//        self.receipt.id = receiptId
//        print("selfreceipt id is: \(self.receipt.id)")
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
//        // Write receipt data to Firebase
//        receiptRef.setValue(receiptData) { error, _ in
//            if let error = error {
//                print("Error saving receipt: \(error.localizedDescription)")
//                completion(false)
//            } else {
//                // If the receipt is saved successfully, update the user's receipts
//                self.userViewModel.addReceiptToUser(userId: userId ?? "BAD7", receiptId: receiptId) { success in
//                    if success {
//                        // Set the class member receipt to the saved receipt
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
//    //function for creating a new receipt object?
//    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]){
//        //create and format date
//        // Create a DateFormatter
//        let dateFormatter = DateFormatter()
//        // Set the desired format for the date
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        // Get the current date
//        let currentDate = Date()
//
//        // Convert the currentDate to a string using the dateFormatter
//        let dateString = dateFormatter.string(from: currentDate)
//        
//        let id = self.getUser()
//        
//        let newReceipt = Receipt(
//            userId: id ?? "BAD8",
//            name: name,
//            date: dateString,
//            
//            //MUST BE FIXED
//            createdAt: "United States",
//            //MUST BE FIXED
//            
//            tax: tax,
//            price: price,
//            items: items,
//            people: people
//        )
//        //self.receipt.id =
//        self.receipt = newReceipt
//    }
//    
//    func setPeople() {
//        if let currentUser = getUser() {
//            let currentUserPerson = LegitP(id: dbRef.child("people").childByAutoId().key ?? "BAD5", name: userViewModel.currentUser?.name ?? "BAD8")
//            if !people.contains(where: { $0.name == currentUserPerson.name }) {
//                people.append(currentUserPerson)
//            }
//        }
//        
//        // Assign a Firebase generated key to each person in the list
//        for index in people.indices {
//            if people[index].id.isEmpty {
//                people[index].id = dbRef.child("people").childByAutoId().key ?? "BAD6"
//            }
//        }
//    }
//
//    func getUser() -> String? {
//        let currentUser = userViewModel.currentUser
//        let id = userViewModel.currentUser?.id
//        
//        return id
//    }
//    
//    func updateReceipt(){
//        //TODO
//    }
//    
//    func addPersonReceipt(){
//        //TODO
//        
//    }
//    
//    func addItemReceipt(){
//        //TODO
//        
//    }
//    
//    func deleteReceipt(){
//        //TODO
//    }
//}
