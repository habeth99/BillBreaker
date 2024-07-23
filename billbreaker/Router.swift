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
    @Published var selectedTab: Tab = .home
    @Published var selectedReceiptId: String?
    
    func reset() {
        path = NavigationPath()
        selectedTab = .home
        selectedReceiptId = nil
    }
}

