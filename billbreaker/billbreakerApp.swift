//
//  billbreakerApp.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//

import SwiftUI
import FirebaseCore
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      print("firebase configures!")
    FirebaseApp.configure()

    return true
  }
}

@main
struct billbreakerApp: App {
  // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var viewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            WhichView()
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.checkUserSession()
                }
    }
  }
}

