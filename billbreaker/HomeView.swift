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
            if rviewModel.hasAttemptedFetch && rviewModel.receiptList.isEmpty {
                EmptyStateView()
            } else {
                ReceiptListView(rviewModel: rviewModel)
            }
        }
        .navigationTitle("Fat Check")
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Text("Fat Check")
//                    .font(.largeTitle.bold())
//                    .padding(.top, -15) // Adjust this value as needed
//            }
//        }
        .onAppear {
            if !rviewModel.hasAttemptedFetch {
                Task {
                    await rviewModel.fetchUserReceipts()
                }
            }
        }
    }
}


