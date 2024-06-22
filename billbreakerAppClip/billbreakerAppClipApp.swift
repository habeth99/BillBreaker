//
//  billbreakerAppClipApp.swift
//  billbreakerAppClip
//
//  Created by Nick Habeth on 6/20/24.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct billbreakerAppClipApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ClipBillDetailView()
        }
    }
}
