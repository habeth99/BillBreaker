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
    @Published var receipt: Receipt
    //@Published var user: UserViewModel
    @Published var item: ItemViewModel?
    @Published var people: PersonViewModel?
    
    // could be BAD but making user an environment variable
    var userViewModel: UserViewModel
    
    private var dbRef = Database.database().reference()
    
    init(//receipt: Receipt,
         user: UserViewModel) {
        self.userViewModel = user
        self.receipt = Receipt()
        // Load or observe changes based on the user
        //loadReceiptsForUser()
    }
    
//    init(receipt: Receipt, userViewModel: UserViewModel) {
//        
//        self.receipt = receipt
//        self.user = userViewModel
//        
//    }
    
    func getUserReceipts(){
        //TODO
    }
    
    func getReceipt(){
        // TODO
        // should return the info for one receipt that is tied to the current user
        // probably one receipt object
        
        // return receipt
    }
    
    //function to write a receipt and make sure its added to the current user
    func saveReceipt(completion: @escaping (Bool) -> Void) {
        let userId = self.getUser()
        
        print("Saving with items: \(receipt.items ?? [])")
        print("Saving with people: \(receipt.people ?? [])")
        
        let receiptRef = dbRef.child("receipts").child(userId).childByAutoId()
        let receiptId = receiptRef.key ?? ""
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

        // Write receipt data to Firebase
        receiptRef.setValue(receiptData) { error, _ in
            if let error = error {
                print("Error saving receipt: \(error.localizedDescription)")
                completion(false)
            } else {
                // If the receipt is saved successfully, update the user's receipts
                self.userViewModel.addReceiptToUser(userId: userId, receiptId: receiptId, completion: completion)
            }
        }
    }
    
    //function for creating a new receipt object?
    func newReceipt(name: String, tax: Double, price: Double, items: [Item], people: [LegitP]){
        //create and format date
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        // Set the desired format for the date
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Get the current date
        let currentDate = Date()

        // Convert the currentDate to a string using the dateFormatter
        let dateString = dateFormatter.string(from: currentDate)
        
        let id = self.getUser()
        
        let newReceipt = Receipt(
            userId: id,
            name: name,
            date: dateString,
            
            //MUST BE FIXED
            createdAt: "United States",
            //MUST BE FIXED
            
            tax: tax,
            price: price,
            items: items,
            people: people
        )
        
        self.receipt = newReceipt
    }

    func getUser() -> String {
        let currentUser = userViewModel.currentUser?.id ?? "BAD3"
        
        return currentUser
    }
    
    func updateReceipt(){
        //TODO
    }
    
    func addPersonReceipt(){
        //TODO
        
    }
    
    func addItemReceipt(){
        //TODO
        
    }
    
    func deleteReceipt(){
        //TODO
    }
}
