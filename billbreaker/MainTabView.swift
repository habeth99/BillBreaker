//
//  MainTabView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/19/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    @StateObject var transformer = ReceiptProcessor()
    @State private var isReceiptFlowActive = false
    @State private var hideAddButton = false
    
    
    var body: some View {
        ZStack {
            TabView(selection: $router.selectedTab) {
                
                NavigationStack {
                    SettingsView()
                }
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Router.Tab.settings)
                
                NavigationStack(path: $router.path) {
                    HomeView(rviewModel: ReceiptViewModel())
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .receipt(let receiptRoute):
                                switch receiptRoute {
//                                case .preDetails(let receiptId):
//                                    PreDetailsView(rviewModel: ReceiptViewModel(), receiptId: receiptId)
                                case .details(let receiptId):
                                    BillDetailsView(rviewModel: ReceiptViewModel(), receiptId: receiptId)
                                        .toolbar(.hidden, for: .tabBar)
                                }
                            default:
                                EmptyView()
                            }
                        }
                }
                .tabItem {
                    Label("Checks", systemImage: "scroll")
                }
                .tag(Router.Tab.home)
                
                Spacer()
            }
            .overlay(
                Group {
                    if (router.path.isEmpty && router.selectedTab == .home) || router.selectedTab == .settings {
                        AddButton(action: {
                            router.navToCamera()
                        })
                        .padding(.trailing, 22)
                        .padding(.bottom, -12)
                    }
                }
            )
            
            if router.isScanFlowActive {
                ScanFlowView(transformer: transformer)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .fullScreenCover(isPresented: $router.isCameraPresented) {
            HomeCameraView(transformer: transformer)
        }
    }
}

struct ScanFlowView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    @ObservedObject var transformer: ReceiptProcessor
    
    var body: some View {
        NavigationStack(path: $router.scanPath) {
            ReviewView(transformer: transformer)
                .navigationDestination(for: ScanRoute.self) { route in
                    switch route {
                    case .people:
                        AddPeopleView(userName: viewModel.currentUser?.name ?? "FatCheck User", transformer: transformer)
                    case .review:
                        SaveCheckView(transformer: transformer)
                    case .items:
                        EmptyView() // We don't need this case anymore
                    }
                }
        }
        .transition(.opacity)
    }
}


