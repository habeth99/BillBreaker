//
//  TabView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.path) {
                HomeView(viewModel: viewModel)
                    .navigationDestination(for: String.self) { route in
                        switch route {
                        case "BillDetails":
                            if let receiptId = router.selectedReceiptId {
                                BillDetailsView(rviewModel: ReceiptViewModel(user: viewModel), receiptId: receiptId)
                            }
                        default:
                            EmptyView()
                        }
                    }
            }
            .tabItem {
                    Label("Home", systemImage: "house")
            }
            .tag(Tab.home)
                
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(Tab.profile)
        }
    }
}
