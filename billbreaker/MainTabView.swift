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
            GeometryReader{ geometry in
                
                CameraView()
                    .frame(height: geometry.size.height - geometry.safeAreaInsets.bottom )
            }
            .tabItem {
                Label("Scan", systemImage: "camera")
            }
            .tag(Tab.scan)
            .onAppear{
                NotificationCenter.default.post(name: NSNotification.Name("RefreshScanCheck"), object: nil)
            }
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
