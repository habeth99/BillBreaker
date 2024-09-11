//
//  Venmo.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/9/24.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import Firebase

class PayBack: ObservableObject {
    func payWithVenmo(recipient: String, amount: String) {
        let venmoUsername = recipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let venmoAmount = amount.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let venmoURL = URL(string: "venmo://paycharge?txn=pay&recipients=\(venmoUsername)&amount=\(venmoAmount)")
        
        if let url = venmoURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Venmo app is not installed, handle this case (e.g., open App Store or Venmo website)
            if let fallbackURL = URL(string: "https://venmo.com/") {
                UIApplication.shared.open(fallbackURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func fetchVenmoHandle(forUserID userID: String, completion: @escaping (String?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users").child(userID).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let venmoHandle = userData["venmoHandle"] as? String {
                completion(venmoHandle)
            } else {
                completion(nil)
            }
        } withCancel: { error in
            print("Error fetching Venmo handle: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
    func openCashApp(recipient: String, amount: String) {
        // Ensure the recipient starts with '$' and remove any spaces
        let formattedRecipient = recipient.hasPrefix("$") ? recipient : "$\(recipient)"
        let cleanRecipient = formattedRecipient.replacingOccurrences(of: " ", with: "")
        
        // Format the amount to ensure it's a valid decimal
        let cleanAmount = amount.replacingOccurrences(of: "$", with: "")
        
        // Construct and encode the URL
        let urlString = "cashapp://cash.app/pay/\(cleanRecipient)/\(cleanAmount)"
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("Failed to create Cash App URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
                if !success {
                    print("Failed to open Cash App")
                    // Optionally, handle the failure (e.g., show an alert to the user)
                }
            }
        } else {
            print("Cash App is not installed")
            // Optionally, open the App Store or show a message to the user
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/cash-app/id711923939") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
}
