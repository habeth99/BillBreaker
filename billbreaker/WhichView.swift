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
    @State private var deepLinkReceiptId: String?
    
    var body: some View {
        ZStack {
            if isLoading {
                SplashView()
            } else if viewModel.isUserAuthenticated {
                MainTabView(deepLinkReceiptId: $deepLinkReceiptId)
            } else {
                LandingPageView()
            }
        }
        .onAppear {
            checkAuthStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: .openReceiptDetail)) { notification in
            if let receiptId = notification.userInfo?["receiptId"] as? String {
                deepLinkReceiptId = receiptId
                // Ensure the user is authenticated when deep linking
                viewModel.checkUserSession()
                isLoading = false
            }
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

