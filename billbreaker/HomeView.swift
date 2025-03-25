//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

struct HomeView: View {
    @StateObject var rviewModel: ReceiptViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        Group {
            if rviewModel.receiptList.isEmpty {
                EmptyStateView()
            } else {
                ReceiptListView(rviewModel: rviewModel)
            }
        }
        .navigationTitle("Fat Check")
        .onAppear {
            Task {
                await rviewModel.fetchUserReceipts()
            }
            
        }
    }
}


