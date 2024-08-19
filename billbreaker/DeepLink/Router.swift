//
//  DeepLinkViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/17/24.
//

import SwiftUI
import Foundation

class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var selectedId: String?
    @Published var selectedTab: Tab = .home
    @Published var isCameraPresented = false
    
    enum Tab: Hashable {
        case home, settings
    }
    
    func selectTab(_ tab: Tab) {
        selectedTab = tab
    }
    
    func navigateToReceipt(id: String) {
        path.append(AppRoute.receipt(.details(receiptId: id)))
    }

    func navigateToMainTab(_ tab: MainTabRoute) {
        path.append(AppRoute.mainTab(tab))
    }
    
    func navigateToItemsScanView(_ tab: ScanRoute) {
        path.append(AppRoute.scan(tab))
    }
    
//    func navToCamera() {
//        path.append(AppRoute.photo(.camera))
//    }
    func navToCamera() {
        isCameraPresented = true
    }
    
    func dismissCamera() {
        isCameraPresented = false
    }
    
    func reset() {
        path.removeLast(path.count)
    }
}

enum AppRoute: Hashable {
    case mainTab(MainTabRoute)
    case receipt(ReceiptRoute)
    case scan(ScanRoute)
    case photo(PhotoRoute)
}

enum MainTabRoute: Hashable {
    case home
    case importPhoto
    case settings
}

enum ScanRoute: Hashable {
    case items
    case people
    case review
}

enum PhotoRoute: Hashable {
    case camera
}

enum ReceiptRoute: Hashable {
    case details(receiptId: String)
}
