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
                                case .details(let receiptId):
                                    BillDetailsView(rviewModel: ReceiptViewModel(), receiptId: receiptId)
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
                AddButton(action: {
                    router.navToCamera()
                })
                //.padding(),
                //alignment: .bottom
                .padding(.trailing, 22)
                .padding(.bottom, -12)
            )
            
            if router.isScanFlowActive {
                ScanFlowView(transformer: transformer)
                    .environmentObject(router)
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
    @ObservedObject var transformer: ReceiptProcessor
    
    var body: some View {
        NavigationStack(path: $router.scanPath) {
            ReviewView(transformer: transformer)
                .navigationDestination(for: ScanRoute.self) { route in
                    switch route {
                    case .items:
                        ReviewView(transformer: transformer)
                    case .people:
                        AddPeopleView(transformer: transformer)
                    case .review:
                        SaveCheckView(transformer: transformer)
                    }
                }
        }
        .transition(.opacity)
    }
}


