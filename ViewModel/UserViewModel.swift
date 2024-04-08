//
//  UserViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Combine
import FirebaseDatabase

class UserViewModel: ObservableObject {
    @Published var user: User?
    
    private var dbRef = Database.database().reference()
    
    // Fetch user data from Firebase and decode into User
    func fetchUser(userID: String) {
        dbRef.child("users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let userData = try? JSONSerialization.data(withJSONObject: value),
                  let user = try? JSONDecoder().decode(User.self, from: userData) else { return }
            DispatchQueue.main.async {
                self.user = user
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
        guard let user = user else { return }
        writeUserToFirebase(user)
    }
}


