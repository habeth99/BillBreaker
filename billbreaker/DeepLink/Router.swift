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
    @Published var linkReceiptId = ""
    
    func navigate(to route: Route) {
        print("Navigating to: \(route)")
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}

enum Route: Hashable {
    case home
    case camera
    case importPhoto
    case settings
    case billDetails(receiptId: String)
}

