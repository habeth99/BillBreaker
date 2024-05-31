//
//  UserViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//
import Foundation
import Combine
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class UserViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var currentUser: User?
    
    private var userID: String?
    
    private var dbRef = Database.database().reference()
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        dbRef = Database.database().reference()
        if let currentUser = Auth.auth().currentUser {
            self.userID = currentUser.uid
            print("Authenticated user ID: \(self.userID ?? "No user ID")")
            self.isUserAuthenticated = true
            fetchUser()
        } else {
            print("No authenticated user found.")
        }
    }
    
    
    // Fetch user data from Firebase and decode into User
    // Sign up a new user
    func signUp(email: String, password: String, name: String, venmoHandle: String, cashAppHandle: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            let newUser = User(id: user.uid, name: name, email: email, venmoHandle: venmoHandle, cashAppHandle: cashAppHandle, receipts: []) // Assuming your User struct includes an email field now.
            self.writeUserToFirebase(newUser)
            self.currentUser = newUser
            
//            guard let user = authResult?.user else { return }
//            self.fetchUser(userId: user.uid)
            
        }
    }

    // Sign in an existing user
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            print("User1: \(user.uid)")
            //self.fetchUser(userId: user.uid)
            self.fetchUser()
        }
        //print("User2: \(self.currentUser?.id ?? "BAD1")")
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserAuthenticated = false
            self.currentUser = nil // Clear the local user data
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func fetchUser() {
        print("fetchUser called.")
        guard let userID = userID else {
            print("UserID is nil.")
            return
        }

        print("Fetching user data for userID: \(userID)")

        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            print("User data snapshot: \(snapshot)")

            guard snapshot.exists() else {
                print("Snapshot does not exist.")
                return
            }

            guard let value = snapshot.value as? [String: Any] else {
                print("No user data found for userID: \(userID)")
                return
            }

            print("User data snapshot value: \(value)")

            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let user = try JSONDecoder().decode(User.self, from: data)
                print("Decoded user: \(user)")
                self.currentUser = user
                self.isUserAuthenticated = true
                //self.getUserReceipts() // Fetch receipts after getting the user
            } catch let error {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    // Write User instance to Firebase
    func writeUserToFirebase(_ user: User) {
        guard let userData = try? JSONEncoder().encode(user),
              let userDict = try? JSONSerialization.jsonObject(with: userData) as? [String: Any] else { return }
        dbRef.child("users").child(user.id).setValue(userDict)
    }
    
    // Update User data in Firebase
    func updateUser() {
        guard let currentUser = currentUser else { return }
        writeUserToFirebase(currentUser)
    }
    
    func deleteAccount() {
        //TODO
    }
    
    func printCurrentUserId() {
        if let currentUser = self.currentUser {
            print("Current user ID is: \(currentUser.id)")
        } else {
            print("No current user is logged in.")
        }
    }
    
    //function to add a receipt a user
    func addReceiptToUser(userId: String, receiptId: String, completion: @escaping (Bool) -> Void) {
        let userReceiptsRef = dbRef.child("users").child(userId).child("receipts")
        
        // Retrieve current receipts to append the new one
        userReceiptsRef.observeSingleEvent(of: .value, with: { snapshot in
            var receipts: [String]
            if let existingReceipts = snapshot.value as? [String] {
                receipts = existingReceipts
            } else {
                receipts = []
            }

            // Append the new receipt ID
            receipts.append(receiptId)

            // Update the user's receipts in Firebase
            userReceiptsRef.setValue(receipts) { error, _ in
                if let error = error {
                    print("Error updating user receipts: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        })
    }
}



