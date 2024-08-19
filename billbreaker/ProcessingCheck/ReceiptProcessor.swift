//
//  ReceiptProcessor.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/6/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Combine


class ReceiptProcessor: ObservableObject {
    @Published var receipt = Receipt()
    let dbRef = Database.database().reference()
    
//    func transformReceipt(apiReceipt: APIReceipt) async {
//        self.receipt = Receipt.from(apiReceipt: apiReceipt)
//        receipt.userId = Receipt.getUserdId() ?? ""
//    }
//    @MainActor
//    func transformReceipt(apiReceipt: APIReceipt) async {
//        print("APIReceipt is: \(apiReceipt)")
//        let transformedReceipt = Receipt.from(apiReceipt: apiReceipt)
//        print("transformedReceipt is: \(transformedReceipt)")
//        DispatchQueue.main.async {
//            self.receipt = transformedReceipt
//        }
//    }
    @MainActor
    func transformReceipt(apiReceipt: APIReceipt) async {
        print("APIReceipt is: \(apiReceipt)")
        var transformedReceipt = Receipt.from(apiReceipt: apiReceipt)
        
        // Generate and assign receipt ID
        let recId = createRecId()
        transformedReceipt.id = recId
        
        // Generate and assign item IDs
        for i in 0..<transformedReceipt.items!.count {
            transformedReceipt.items![i].id = createItemId(receiptId: recId)
        }
        
        // Generate and assign person IDs (if needed)
//        for i in 0..<transformedReceipt.people!.count {
//            transformedReceipt.people![i].id = createPersonId(receiptId: recId)
//        }
        
        print("transformedReceipt is: \(transformedReceipt)")
        
        DispatchQueue.main.async {
            self.receipt = transformedReceipt
        }
    }
    
    func createRecId() -> String {
        return dbRef.child("receipts").childByAutoId().key ?? ""
    }

    func createItemId(receiptId: String) -> String {
        return dbRef.child("receipts").child(receiptId).child("items").childByAutoId().key ?? ""
    }

    func createPersonId(receiptId: String) -> String {
        return dbRef.child("receipts").child(receiptId).child("persons").childByAutoId().key ?? ""
    }
    
    func saveReceipt2(completion: @escaping (Bool) -> Void) {

        if receipt.id.isEmpty {
            receipt.id = dbRef.child("receipts").childByAutoId().key ?? ""
            print("Generated new receipt ID: \(receipt.id)")
        }
        
        receipt.items = receipt.items?.map { item in
            var updatedItem = item
            if updatedItem.id.isEmpty {
                updatedItem.id = dbRef.child("receipts").child(receipt.id).child("items").childByAutoId().key ?? ""
            }
            return updatedItem
        }
        
        receipt.people = receipt.people?.map { person in
            var updatedPerson = person
            if updatedPerson.id.isEmpty {
                updatedPerson.id = dbRef.child("receipts").child(receipt.id).child("people").childByAutoId().key ?? ""
            }
            return updatedPerson
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
                self.saveReceiptToUser(receiptId: self.receipt.id) { success in
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
    
    func getUserdId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    
    func createLegitPs(guests: [String]) {
        var availableColors: [Color] = [.red, .blue, .green, .orange, .yellow, .gray, .purple, .pink]
        
        self.receipt.people = guests.enumerated().map { index, guestName in
            let color: Color
            if index < availableColors.count {
                // If we still have unique colors, choose one randomly
                let randomIndex = Int.random(in: 0..<availableColors.count)
                color = availableColors.remove(at: randomIndex)
            } else {
                // If we've used all colors, start over with the full list
                availableColors = [.red, .blue, .green, .orange, .yellow, .gray, .purple, .pink]
                let randomIndex = Int.random(in: 0..<availableColors.count)
                color = availableColors.remove(at: randomIndex)
            }
            
            return LegitP(
                id: "",
                name: guestName,
                userId: "",
                claims: [],
                paid: false,
                color: color
            )
        }
    }
    
    func addItem(newItem: Item) {

        newItem.id = self.createItemId(receiptId: receipt.id)
        self.receipt.items?.append(newItem)
        objectWillChange.send()
    }
    
    func updateItem(_ updatedItem: Item) {
        // Update the item in the receipt
        if let index = receipt.items?.firstIndex(where: { $0.id == updatedItem.id }) {
            receipt.items?[index] = updatedItem
        }
        objectWillChange.send()
    }
    
    func saveReceiptToUser(receiptId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = Receipt.getUserdId() else {
            print("Error: No user ID available")
            completion(false)
            return
        }

        let userRef = dbRef.child("users").child(userId)
        
        userRef.observeSingleEvent(of: .value) { snapshot in
            if var userData = snapshot.value as? [String: Any] {
                var receipts = userData["receipts"] as? [String] ?? []
                
                if !receipts.contains(receiptId) {
                    receipts.append(receiptId)
                    userData["receipts"] = receipts
                    
                    userRef.updateChildValues(userData) { error, _ in
                        if let error = error {
                            print("Error updating user's receipts: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            print("Receipt successfully added to user's list")
                            completion(true)
                        }
                    }
                } else {
                    print("Receipt already exists in user's list")
                    completion(true)
                }
            } else {
                let newUserData: [String: Any] = ["receipts": [receiptId]]
                userRef.setValue(newUserData) { error, _ in
                    if let error = error {
                        print("Error creating user's receipts list: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Receipt successfully added to new user's list")
                        completion(true)
                    }
                }
            }
        }
    }
}

