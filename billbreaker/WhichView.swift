//
//  WhichView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

struct WhichView: View {
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        //Group{
            if viewModel.isUserAuthenticated {
                // User is authenticated, show the main app view
                HomeView()
            } else {
                // User is not authenticated, show the login view
                LoginView()
            }
        //}
    }
}

#Preview {
    WhichView()
}
