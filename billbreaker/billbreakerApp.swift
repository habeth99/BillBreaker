//
//  billbreakerApp.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//
import Foundation
import SwiftUI
import FirebaseCore
import Firebase

@main
struct billbreakerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject var viewModel = UserViewModel()
    @StateObject var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationView{
                WhichView()
                    .environmentObject(viewModel)
                    .environmentObject(router)
                    .onOpenURL { url in
                        print("Received URL: \(url)")
                        guard let scheme = url.scheme, scheme == "fatcheck" else { return }
                        guard let receiptId = url.host else { return }
                        
                        print("id is: \(receiptId)")
                        router.reset()
                        router.selectedTab = .home
                        router.selectedReceiptId = receiptId
                
                        router.path.append("BillDetails")
                    }
            }
        }
    }
}

