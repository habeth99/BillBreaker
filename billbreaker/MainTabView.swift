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
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.path) {
                HomeView(rviewModel: ReceiptViewModel())
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .photo(.camera):
                            HomeCameraView()
                        case .receipt(let receiptRoute):
                            switch receiptRoute {
                            case .details(let receiptId):
                                BillDetailsView(rviewModel: ReceiptViewModel(), receiptId: receiptId)
                            }
                        case .scan(let scanRoute):
                            switch scanRoute {
                            case .items:
                                ReviewView(transformer: ReceiptProcessor())
                            case .people:
                                AddPeopleView(transformer: ReceiptProcessor())
                            case .review:
                                SaveCheckView(transformer: ReceiptProcessor())
                            }
                        default:
                            EmptyView()
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(Router.Tab.home)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(Router.Tab.settings)
            
            Spacer()
        }
        .overlay(
            AddButton(action: {
                router.navToCamera()
            })
            .padding(),
            alignment: .bottom
        )
        .fullScreenCover(isPresented: $router.isCameraPresented) {
            HomeCameraView()
        }
    }
}
