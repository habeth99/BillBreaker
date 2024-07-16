//
//  billbreakerApp.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//

import SwiftUI
import FirebaseCore
import Firebase

@main
struct billbreakerApp: App {
  // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var viewModel = UserViewModel()

    var body: some Scene {
        WindowGroup {
            WhichView()
                .environmentObject(viewModel)
    }
  }
}

