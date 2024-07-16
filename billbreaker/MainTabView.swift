//
//  TabView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @Binding var deepLinkReceiptId: String?
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel, deepLinkReceiptId: $deepLinkReceiptId)
                .environmentObject(viewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProfileView()
                .environmentObject (viewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
