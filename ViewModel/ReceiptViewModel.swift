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
    
    func createReceipt(){
        //TODO
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
