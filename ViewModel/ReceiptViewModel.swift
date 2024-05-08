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
    @Published var user: UserViewModel
    @Published var item: ItemViewModel?
    @Published var people: PersonViewModel?
    
    private var dbRef = Database.database().reference()
    
    init(receipt: Receipt, userViewModel: UserViewModel) {
        
        self.receipt = receipt
        self.user = userViewModel
        
    }
    
    func getUserReceipts(){
        //TODO
    }
    
    func getReceipt(){
        // TODO
        // should return the info for one receipt that is tied to the current user
        // probably one receipt object
        
        // return receipt
    }
    
    func addReceiptToUser(){
        //TODO
        let userId = self.user.currentUser?.id ?? "null"
        let userReceiptsRef = dbRef.child("users").child(userId).child("receipts")
        let newReceiptRef = userReceiptsRef.childByAutoId()
        newReceiptRef.setValue(self.receipt)
        
        self.receipt.id = newReceiptRef.key ?? "null"
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
