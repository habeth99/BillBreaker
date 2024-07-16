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
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                SplashView()
            } else if viewModel.isUserAuthenticated {
                HomeView(viewModel: viewModel)
                    .environmentObject(viewModel)
            } else {
                LandingPageView()
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        Task {
            // Simulate a delay to show the splash screen
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds delay
            
            viewModel.checkUserSession()
            
            withAnimation {
                isLoading = false
            }
        }
    }
}

