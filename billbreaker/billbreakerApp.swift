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
    //var viewModel = BillViewModel()
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SignUpView()
            //TestView()
            //HomeView21()
                //.environmentObject(viewModel)
        }
    }
}
