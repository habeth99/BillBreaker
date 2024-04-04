//
//  billbreakerApp.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/22/24.
//

import SwiftUI

@main
struct billbreakerApp: App {
    //var viewModel = BillViewModel()
    var body: some Scene {
        WindowGroup {
            TestView(billName: "Chipotle")
                //.environmentObject(viewModel)
        }
    }
}
