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
    @Published var isScanFlowActive = false
    @Published var scanPath: [ScanRoute] = []
    
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
    
    func startScanFlow() {
        isScanFlowActive = true
        scanPath = [.items]
    }
    
    func navigateInScanFlow(to route: ScanRoute) {
        scanPath.append(route)
    }
    
    func endScanFlow() {
        isScanFlowActive = false
        scanPath.removeAll()
    }
    
    func navToCamera() {
        isCameraPresented = true
    }
    
    func dismissCamera() {
        isCameraPresented = false
    }
    
    func reset() {
        path.removeLast(path.count)
        endScanFlow()
    }
}

enum AppRoute: Hashable {
    case mainTab(MainTabRoute)
    case receipt(ReceiptRoute)
}

enum MainTabRoute: Hashable {
    case home
    //case importPhoto
    case settings
}

enum ScanRoute: Hashable {
    case items
    case people
    case review
}

enum ReceiptRoute: Hashable {
    case details(receiptId: String)
}
