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
                HomeView(viewModel: viewModel)
                    .environmentObject(viewModel)
            } else {
                // User is not authenticated, show the landing page so user can signin, login, or signin with Apple
                LandingPageView()
            }
        //}
    }
}

