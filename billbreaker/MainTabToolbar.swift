//
//  TabView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/16/24.
//

import Foundation
import SwiftUI

//struct MainTabToolbar: View {
//    @EnvironmentObject var viewModel: UserViewModel
//    @EnvironmentObject var router: Router
//    
//    
//    var body: some View {
//        TabView(selection: $router.selectedTab) {
//            HomeTabView()
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//                .tag(Tab.home)
//                
//            ProfileTabView()
//                tabItem {
//                    Label("Profile", systemImage: "person")
//                }
//                .tag(Tab.profile)
//        }
//    }
//}
//
//struct HomeTabView: View {
//    @EnvironmentObject var viewModel: UserViewModel
//    @EnvironmentObject var router: Router
//    
//    var body: some View {
//        NavigationStack(path: $router.path) {
//            HomeView(viewModel: viewModel)
//                .navigationDestination(for: String.self) { route in
//                    switch route {
//                    case "BillDetails":
//                        if let receiptId = router.selectedReceiptId {
//                            BillDetailsView(rviewModel: ReceiptViewModel(user: viewModel), receiptId: receiptId)
//                        }
//                    default:
//                        EmptyView()
//                    }
//                }
//        }
//    }
//}
//
//struct ProfileTabView: View {
//    var body: some View {
//        NavigationView {
//            ProfileView()
//        }
//    }
//}

//struct MainTabToolbar: View {
//    @ObservedObject var router: Router
//    
//    var body: some View {
//        HStack {
//            TabBarButton(imageName: "camera", text: "Camera", isSelected: $router.currentRoute == .camera) {
//                router.currentRoute = .camera
//            }
//            
//            Spacer()
//            
//            TabBarButton(imageName: "archivebox", text: "Archive", isSelected: router.currentRoute == .archive) {
//                router.currentRoute = .archive
//            }
//            
//            Spacer()
//            
//            TabBarButton(imageName: "gear", text: "Settings", isSelected: router.currentRoute == .settings) {
//                router.currentRoute = .settings
//            }
//        }
//        .padding()
//        .background(Color.black.opacity(0.6))
//    }
//}
struct MainTabToolbar: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        HStack {
//            ArchiveButton(imageName: "camera", text: "Camera") {
//                router.path.removeLast(router.path.count)
//            }
            ArchiveButton(imageName: "archivebox", text: "Archive") {
                router.path.append("Archive")
            }
            
            ProfileButton(imageName: "gear", text: "Settings") {
                    router.path.append("Settings")
            }
            
//            Spacer()
//            
//            CustomButton(imageName: "gear", text: "Settings") {
//                router.path.append("Settings")
//            }
        }
        .padding()
        
        .background(Color.black.opacity(0.0))
    }
}

