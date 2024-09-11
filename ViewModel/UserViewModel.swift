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
import CryptoKit
import AuthenticationServices

struct OnboardingAnswers: Codable {
    var mostExcitedFeature: String?
    var defaultTipPercentage: Bool?
    var wantsPushNotifications: Bool?
}

class UserViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isUserDataLoaded = false
    @Published var isNewUser = false
    @Published var onboardingAnswers = OnboardingAnswers()
    
    private var userID: String?
    private var currentNonce: String?
    
    private var dbRef = Database.database().reference()
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var cancellables = Set<AnyCancellable>()

    init() {
        Task {
            await setupInitialState()
        }
    }
    
    private func setupInitialState() async {
        if let currentUser = Auth.auth().currentUser {
            await updateAuthState(userId: currentUser.uid, isAuthenticated: true)
        } else {
            await updateAuthState(userId: nil, isAuthenticated: false)
        }
    }
    
    private func updateAuthState(userId: String?, isAuthenticated: Bool) async {
        //print("UserViewModel: Updating auth state - userId: \(userId ?? "nil"), isAuthenticated: \(isAuthenticated)")
        await MainActor.run {
            self.userID = userId
            self.isUserAuthenticated = isAuthenticated
            if isAuthenticated {
                //print("UserViewModel: Authenticated user ID: \(self.userID ?? "No user ID")")
                self.setupUserListener()
                self.fetchUser()
            } else {
                print("UserViewModel: No authenticated user found.")
                self.currentUser = nil
            }
        }
    }
    
    func checkUserSession() {
        //print("UserViewModel: Starting checkUserSession")
        Task {
            await updateAuthState(userId: Auth.auth().currentUser?.uid, isAuthenticated: Auth.auth().currentUser != nil)
            //print("UserViewModel: Finished checkUserSession - isUserAuthenticated: \(isUserAuthenticated), userID: \(userID ?? "nil")")
        }
    }
    
    func fetchUser() {
        //print("UserViewModel: Starting fetchUser")
        guard let userID = userID else {
            print("UserViewModel: fetchUser - UserID is nil.")
            return
        }

        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            //print("UserViewModel: fetchUser - Snapshot received")
            
            guard snapshot.exists() else {
                print("UserViewModel: fetchUser - User data does not exist.")
                return
            }
            
            //print("UserViewModel: fetchUser - Snapshot contents:")
            //self.printSnapshot(snapshot)
            
            var userData: [String: Any] = [:]
            
            // Extract only the needed fields
            for field in ["name", "email", "cashAppHandle", "venmoHandle"] {
                userData[field] = snapshot.childSnapshot(forPath: field).value
                //print("UserViewModel: fetchUser - \(field): \(String(describing: userData[field]))")
            }
            
            // Add userID to the userData
            userData["id"] = userID
            //print("UserViewModel: fetchUser - id: \(userID)")
            
            // Handle receipts separately as they might be more complex
            if let receipts = snapshot.childSnapshot(forPath: "receipts").value as? [String: Any] {
                userData["receipts"] = receipts
                //print("UserViewModel: fetchUser - receipts: \(receipts)")
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: userData)
                let user = try JSONDecoder().decode(User.self, from: data)
                
                Task { @MainActor in
                    self.currentUser = user
                    self.isUserAuthenticated = true
                    self.isUserDataLoaded = true
                    //print("UserViewModel: fetchUser - User data loaded successfully. isUserAuthenticated: \(self.isUserAuthenticated), isUserDataLoaded: \(self.isUserDataLoaded)")
                    //print("UserViewModel: fetchUser - Decoded user: \(user)")
                }
                self.setupUserListener()
            } catch {
                print("UserViewModel: Error decoding user: \(error.localizedDescription)")
            }
        }
    }

    // Helper function to print snapshot contents
    private func printSnapshot(_ snapshot: DataSnapshot, indent: String = "") {
        let value = snapshot.value ?? "null"
        print("\(indent)\(snapshot.key): \(value)")
        
        if let children = snapshot.children.allObjects as? [DataSnapshot] {
            for child in children {
                printSnapshot(child, indent: indent + "  ")
            }
        }
    }
    
    
    
    

    private func setupUserListener() {
        guard let userID = userID else { return }
        dbRef.child("users").child(userID).observe(.value) { [weak self] snapshot in
            guard let self = self, let value = snapshot.value as? [String: Any] else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(User.self, from: data)
                Task { @MainActor in
                    self.currentUser = user
                }
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
            }
        }
    }

    
//================================================================================================
    //functions: signOut, deleteAccount, updateUser, printCurrentUserId, saveOnboardingAnswers
    
    func updateUser(name: String, email: String, venmoHandle: String, cashAppHandle: String) {
        let userRef = dbRef.child("users").child(User.getUserdId() ?? "")
        
        let updates: [String: Any] = [
            "name": name,
            "email": email,
            "venmoHandle": venmoHandle,
            "cashAppHandle": cashAppHandle
        ]
        
        userRef.updateChildValues(updates) { error, _ in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
            } else {
                print("User updated successfully")
            }
        }
    }
    
    func printCurrentUserId() {
        if let currentUser = self.currentUser {
            print("Current user ID is: \(currentUser.id)")
        } else {
            print("No current user is logged in.")
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            await MainActor.run {
                // Reset all user-related properties
                self.userID = nil
                self.isUserAuthenticated = false
                self.currentUser = nil
                self.isUserDataLoaded = false
                self.isNewUser = false
                self.onboardingAnswers = OnboardingAnswers()
                self.errorMessage = nil
                
                // Remove any active listeners
                if let handle = self.authStateDidChangeListenerHandle {
                    Auth.auth().removeStateDidChangeListener(handle)
                    self.authStateDidChangeListenerHandle = nil
                }
                
                // Cancel any ongoing publishers
                self.cancellables.removeAll()
            }
            print("User signed out successfully and app state reset.")
        } catch {
            await MainActor.run {
                self.errorMessage = "Error signing out: \(error.localizedDescription)"
            }
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func deleteAccount() async {
        print("Starting account deletion process")
        
        guard let currentUser = Auth.auth().currentUser else {
            print("Error: No authenticated user found")
            return
        }
        
        let userId = currentUser.uid
        print("Authenticated user ID: \(userId)")
        
        // 1. Delete user data from Firebase Realtime Database
        do {
            print("Attempting to delete user data from Realtime Database")
            try await dbRef.child("users").child(userId).removeValue()
            print("User data successfully deleted from Realtime Database")
        } catch {
            print("Error deleting user data from Realtime Database: \(error.localizedDescription)")
            return
        }
        
        // 2. Delete the user's authentication account
        do {
            print("Attempting to delete user authentication account")
            try await currentUser.delete()
            print("User authentication account successfully deleted")
            
            // 3. Update the app state
            await updateAuthState(userId: nil, isAuthenticated: false)
            print("App state updated: User signed out")
            
            // 4. Clear local user data
            await MainActor.run {
                self.currentUser = nil
                self.isUserDataLoaded = false
            }
            print("Local user data cleared")
            
        } catch {
            print("Error deleting user authentication account: \(error.localizedDescription)")
        }
    }
    
    func saveOnboardingAnswers() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user")
            return
        }
        
        let userRef = dbRef.child("users").child(userId)
        
        let onboardingData: [String: Any] = [
            "mostExcitedFeature": onboardingAnswers.mostExcitedFeature ?? "",
            "defaultTipPercentage": onboardingAnswers.defaultTipPercentage ?? false,
            "wantsPushNotifications": onboardingAnswers.wantsPushNotifications ?? false
        ]
        
        userRef.updateChildValues(onboardingData) { error, _ in
            if let error = error {
                print("Error saving onboarding answers: \(error)")
            } else {
                print("Onboarding answers successfully saved")
                self.isNewUser = false
            }
        }
    }
    
//================================================================================================
    //Login Credentials for Apple
    
//================================================================================================
    

    
    // function for starting apple sign in with a request
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = sha256(nonce)
    }
    
    func handleSignInWithCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            print("Sign-in failure: \(failure.localizedDescription)")
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
                        if let firebaseUser: FirebaseAuth.User? = authResult.user {
                            var userName = firebaseUser?.displayName ?? "No Name"
                            if let fullName = appleIDCredential.fullName {
                                userName = PersonNameComponentsFormatter().string(from: fullName).trimmingCharacters(in: .whitespaces)
                            }

                            let billbreakerUser = User(id: firebaseUser?.uid,
                                                       name: userName,
                                                       email: firebaseUser?.email ?? "",
                                                       venmoHandle: "",
                                                       cashAppHandle: "",
                                                       receipts: [])
                            
                            print("Signed in user: \(billbreakerUser)")
                            
                            // Update auth state and fetch user data
                            await self.updateAuthState(userId: firebaseUser?.uid, isAuthenticated: true)
                            
                            // Check if the user already exists in the database
                            let ref = Database.database().reference().child("users").child(firebaseUser!.uid)
                            ref.observeSingleEvent(of: .value) { [weak self] snapshot in
                                guard let self = self else { return }
                                
                                if !snapshot.exists() {
                                    // User does not exist, store their data
                                    self.storeUserData(billbreakerUser, fullName: userName)
                                }
                                
                                // Fetch user data to ensure we have the most up-to-date information
                                self.fetchUser()
                                
                                // Update UI on the main thread
                                DispatchQueue.main.async {
                                    self.isUserAuthenticated = true
                                    self.isUserDataLoaded = true
                                    print("User authenticated and data loaded successfully")
                                }
                            }
                        } else {
                            print("Error: Firebase user is nil")
                        }
                    } catch {
                        print("Error during sign-in: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    

    func storeUserData(_ user: User?, fullName: String?) {
        guard let currentUser = user else {
            print("Current user is nil.")
            return
        }

        // Create the user data dictionary
        var userData: [String: Any] = [
            "id": currentUser.id,
            "email": currentUser.email,
            "receipts": currentUser.receipts,
            "name": fullName ?? currentUser.name
        ]

        // Store user data in Firebase
        dbRef.child("users").child(currentUser.id).setValue(userData) { error, _ in
            if let error = error {
                print("Error writing user data to Firebase: \(error.localizedDescription)")
            } else {
                print("User data written to Firebase successfully.")
            }
        }
    }

    
    //helper functions
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if length == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    
    //helper function to create the SHA256
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }


//================================================================================================
    //End Apple
        
//================================================================================================
    
}
