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
    
    func navigateToReceipt(id: String) {
        path.append(AppRoute.receipt(.details(receiptId: id)))
    }

    func navigateToMainTab(_ tab: MainTabRoute) {
        path.append(AppRoute.mainTab(tab))
    }
}

enum AppRoute: Hashable {
    case mainTab(MainTabRoute)
    case receipt(ReceiptRoute)
}

enum MainTabRoute: Hashable {
    case home
    case importPhoto
    case settings
}

enum ReceiptRoute: Hashable {
    case details(receiptId: String)
}
