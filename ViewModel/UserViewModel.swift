//
//  UserViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.

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
    private var cancellables = Set<AnyCancellable>()

    init() {
        if let currentUser = Auth.auth().currentUser {
            self.userID = currentUser.uid
            
            print("Authenticated user ID: \(self.userID ?? "No user ID")")
            self.isUserAuthenticated = true
            setupUserListener()
            //fetchUser()
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
            let newUser = User(id: user.uid, name: name, email: email, venmoHandle: venmoHandle, cashAppHandle: cashAppHandle, receipts: [])
            print("New user created: \(newUser)")
            self.writeUserToFirebase(newUser)
            self.currentUser = newUser
            //maybe change
            self.isUserAuthenticated = true
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
            print("User signed in: \(user.uid)")
            self.fetchUser()
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isUserAuthenticated = false
            self.currentUser = nil // Clear the local user data
            print("User signed out successfully.")
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

        //dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            print("User data snapshot: \(snapshot)")

            guard snapshot.exists() else {
                print("Snapshot does not exist.")
                return
            }

            guard let value = snapshot.value as? [String: Any] else {
                print("Snapshot does not contain a valid dictionary. Snapshot value: \(snapshot.value ?? "nil")")
                return
            }

            print("User data snapshot value: \(value)")

            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: [])
                let user = try JSONDecoder().decode(User.self, from: data)
                print("Decoded user: \(user)")
                self!.currentUser = user
                self!.isUserAuthenticated = true
                self?.setupUserListener()
            } catch let error {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }) { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }

    // Write User instance to Firebase
    func writeUserToFirebase(_ user: User) {
        print("Writing user to Firebase: \(user)")
        guard let userData = try? JSONEncoder().encode(user),
              let userDict = try? JSONSerialization.jsonObject(with: userData) as? [String: Any] else {
            print("Error encoding user data.")
            return
        }
        dbRef.child("users").child(user.id).setValue(userDict) { error, _ in
            if let error = error {
                print("Error writing user to Firebase: \(error.localizedDescription)")
            } else {
                print("User written to Firebase successfully.")
            }
        }
    }
    
    // Update User data in Firebase
    func updateUser() {
        guard let currentUser = currentUser else {
            print("Current user is nil.")
            return
        }
        print("Updating user with ID: \(currentUser.id)")
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
    
    // Function to add a receipt to a user
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
            print("Appending receipt ID: \(receiptId) to user ID: \(userId)")

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
        }
    }

    private func setupUserListener() {
         guard let userID = userID else { return }
         dbRef.child("users").child(userID).observe(.value, with: { [weak self] snapshot in
             print("User data snapshot: \(snapshot)")

             guard snapshot.exists() else {
                 print("Snapshot does not exist.")
                 return
             }

             guard let value = snapshot.value as? [String: Any] else {
                 print("Snapshot does not contain a valid dictionary. Snapshot value: \(snapshot.value ?? "nil")")
                 return
             }

             print("User data snapshot value: \(value)")

             do {
                 let data = try JSONSerialization.data(withJSONObject: value, options: [])
                 let user = try JSONDecoder().decode(User.self, from: data)
                 print("Decoded user: \(user)")
                 self?.currentUser = user
             } catch let error {
                 print("Error decoding user: \(error.localizedDescription)")
             }
         }) { error in
             print("Error fetching user data: \(error.localizedDescription)")
         }
     }
    
}
