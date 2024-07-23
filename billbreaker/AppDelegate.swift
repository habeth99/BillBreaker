//
//  AppDelegate.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/9/24.
//

import Foundation
import UIKit
import Firebase
import UIKit
import SwiftUI
    
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return handleDeepLink(url: url)
    }
    
    private func handleDeepLink(url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            return false
        }
        
        switch host {
        case "receipt":
            if let receiptId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                NotificationCenter.default.post(name: .openReceiptDetail, object: nil, userInfo: ["receiptId": receiptId])
                return true
            }
        default:
            return false
        }
        
        return false
    }
}

extension Notification.Name {
    static let openReceiptDetail = Notification.Name("openReceiptDetail")
}




