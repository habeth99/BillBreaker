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

class UserViewModel: ObservableObject {
    @Published var isUserAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var showLoginView: Bool = false
    @Published var showSignupView: Bool = false
    @Published var errorMessage: String?
    @Published var isUserDataLoaded = false
    
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
        await MainActor.run {
            self.userID = userId
            self.isUserAuthenticated = isAuthenticated
            if isAuthenticated {
                print("Authenticated user ID: \(self.userID ?? "No user ID")")
                self.setupUserListener()
                self.fetchUser()
            } else {
                print("No authenticated user found.")
                self.currentUser = nil
            }
        }
    }
    
    func checkUserSession() {
        Task {
            await updateAuthState(userId: Auth.auth().currentUser?.uid, isAuthenticated: Auth.auth().currentUser != nil)
        }
    }
    

    func signUp(email: String, password: String, name: String, venmoHandle: String, cashAppHandle: String) async {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            let newUser = User(id: user.uid, name: name, email: email, venmoHandle: venmoHandle, cashAppHandle: cashAppHandle, receipts: [])
            print("New user created: \(newUser)")
            writeUserToFirebase(newUser)
            await updateAuthState(userId: user.uid, isAuthenticated: true)
            await MainActor.run {
                self.currentUser = newUser
            }
        } catch {
            print("Error signing up: \(error.localizedDescription)")
            await updateAuthState(userId: nil, isAuthenticated: false)
        }
    }

    func signIn(email: String, password: String) async {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authResult.user
            print("User signed in: \(user.uid)")
            await updateAuthState(userId: user.uid, isAuthenticated: true)
            fetchUser()
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            await updateAuthState(userId: nil, isAuthenticated: false)
        }
    }

    func signOut() async {
        do {
            try Auth.auth().signOut()
            await updateAuthState(userId: nil, isAuthenticated: false)
            print("User signed out successfully.")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    // Write User instance to Firebase
    func writeUserToFirebase(_ user: User) {
        //print("Writing user to Firebase: \(user)")
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
    
//    func getUser() -> String {
//        guard let currUserId = self.currentUser?.id else {
//            print("No current user is logged in.")
//            return ""
//        }
//        return currUserId
//    }
    
    func fetchUser() {
        guard let userID = userID else {
            print("UserID is nil.")
            return
        }

        print("Fetching user data for userID: \(userID)")

        dbRef.child("users").child(userID).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            print("User data snapshot: \(snapshot)")

            guard snapshot.exists(), let value = snapshot.value as? [String: Any] else {
                print("Snapshot does not exist or contain valid data.")
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: value)
                let user = try JSONDecoder().decode(User.self, from: data)
                print("Decoded user: \(user)")
                Task { @MainActor in
                    self.currentUser = user
                    self.isUserAuthenticated = true
                    self.isUserDataLoaded = true
                }
                self.setupUserListener()
            } catch {
                print("Error decoding user: \(error.localizedDescription)")
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
    //Login Credentials for Apple
    
//================================================================================================
    
    // function for starting apple sign in with a request
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = sha256(nonce)
        print("signinwithapplerequest ran fully")
    }
    
    // function that signs in apple user with completion handler
    func handleSignInWithCompletion(_ result: Result<ASAuthorization, Error>) {
        print("top of withcompletion")
        if case .failure(let failure) = result {
            print("failure!")
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("invalid state: a login callback was received, but no login request was sent")
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
                                // Use the full name directly if available
                                userName = PersonNameComponentsFormatter().string(from: fullName).trimmingCharacters(in: .whitespaces)
                            }

                            let billbreakerUser = User(id: firebaseUser?.uid,
                                                       name: userName,
                                                       email: firebaseUser?.email ?? "",
                                                       venmoHandle: "",
                                                       cashAppHandle: "",
                                                       receipts: [])
                            self.currentUser = billbreakerUser
                            print("billbreakerUser is: \(billbreakerUser)")
                            
                            // Check if the user already exists in the database
                            let ref = Database.database().reference().child("users").child(firebaseUser!.uid)
                            ref.observeSingleEvent(of: .value) { snapshot in
                                if !snapshot.exists() {
                                    // User does not exist, store their data
                                    self.storeUserData(billbreakerUser, fullName: userName)
                                }
                                // Set isUserAuthenticated to true
                                self.isUserAuthenticated = true
                                print("User authenticated successfully")
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
        print("top of storeuserdata")
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
