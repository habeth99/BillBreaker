//
//  billbreakerApp.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//

import SwiftUI
import Firebase

@main
struct billbreakerApp: App {
    
    @StateObject var viewModel = UserViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            WhichView()
                .environmentObject(UserViewModel())

        }
    }
}
