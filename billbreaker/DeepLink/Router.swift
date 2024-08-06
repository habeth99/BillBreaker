//
//  DeepLinkViewModel.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/17/24.
//

import SwiftUI
import Foundation

class Router: ObservableObject {
//    @Published var mainTabPath = NavigationPath()
//    @Published var receiptPath = NavigationPath()
    @Published var path = NavigationPath()
    @Published var selectedId: String?
    
    func navigateToReceipt(id: String) {
        path.append(AppRoute.receipt(.details(receiptId: id)))
    }

    func navigateToMainTab(_ tab: MainTabRoute) {
        path.append(AppRoute.mainTab(tab))
    }
//    func navigate(to route: Route) {
//        print("Navigating to: \(route)")
//        path.append(route)
//        print("Current path count: \(path.count)")
//    }
    
//    func navigateBack() {
//        path.removeLast()
//    }
//    
//    func navigateToRoot() {
//        path.removeLast(path.count)
//    }
}

enum AppRoute: Hashable {
    case mainTab(MainTabRoute)
    case receipt(ReceiptRoute)
}

enum MainTabRoute: Hashable {
    case home
    case importPhoto
    case settings
    //case billDetails(receiptId: String)
}

enum ReceiptRoute: Hashable {
    case details(receiptId: String)
}
