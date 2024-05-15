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
    
    private var dbRef = Database.database().reference()
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard let self = self else { return }
            if let user = user {
                // User is signed in
                self.isUserAuthenticated = true
                // Optionally fetch user details from Realtime Database
                Task {
                    self.fetchUser(userId: user.uid)
                }
            } else {
                // No user is signed in
                self.isUserAuthenticated = false
                self.currentUser = nil
            }
        }
    }
    
    deinit {
        if let authStateDidChangeListenerHandle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
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
            self.fetchUser(userId: user.uid)
        }
        print("User2: \(self.currentUser?.id ?? "BAD")")
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

    func fetchUser(userId: String) {
        dbRef.child("users").child(userId).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error: Snapshot is not a valid dictionary")
                return
            }
            do {
                let userData = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(User.self, from: userData)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } catch let error {
                print("Decoding error: \(error)")
            }
        })
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
}



