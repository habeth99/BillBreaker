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
    
    @StateObject var model = DataModel()
    
    init() {
        setupTabBarAppearance()
    }

    var body: some Scene {
        WindowGroup {
            NavigationView{
                WhichView()
                    .environmentObject(viewModel)
                    .environmentObject(router)
                    .environmentObject(model)
                    .onOpenURL { url in
                        print("Received URL: \(url)")
                        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                              components.host == "www.fatcheck.app",
                              components.path.hasPrefix("/receipt/") else { return }
                        
                        let receiptId = components.path.replacingOccurrences(of: "/receipt/", with: "")
                        
                        print("id is: \(receiptId)")
                        
                        router.navigateToReceipt(id: receiptId)
                        //router.reset()
                        //router.selectedTab = .home
                        router.selectedId = receiptId

                        //router.path.append("BillDetails")
                    }
            }
        }
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color(hex: "#30cd31"))
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(Color(hex: "#30cd31"))]
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

