//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showActionSheet = false
    @State private var showingNewReceiptSheet = false
    @State private var showingJoinSheet = false
    @State private var newBillTitle = ""
    
    @Binding var deepLinkReceiptId: String?
    @State private var navigateToReceipt: Receipt?
    
    @StateObject private var rviewModel: ReceiptViewModel
    @EnvironmentObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel, deepLinkReceiptId: Binding<String?>) {
        self._deepLinkReceiptId = deepLinkReceiptId
        self._rviewModel = StateObject(wrappedValue: ReceiptViewModel(user: viewModel))
    }
    
    var body: some View {
        NavigationView {
            ReceiptListView(rviewModel: rviewModel)
                .navigationTitle("My Checks")
                .toolbar {
                    HomeToolbar(
                        onEdit: rviewModel.handleEdit,
                        onJoin: { showingJoinSheet = true },
                        onAdd: { showingNewReceiptSheet = true }
                    )
                }
        }
        .sheet(isPresented: $showingNewReceiptSheet) {
            NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel(user: viewModel))
        }
        .sheet(isPresented: $showingJoinSheet) {
            JoinReceiptView(isPresented: $showingJoinSheet, rviewModel: rviewModel)
        }
        .onAppear {
            print("HomeView appeared")
            Task{
                await rviewModel.fetchUserReceipts()
                print("User: \(String(describing: viewModel.currentUser))")
            }
//            if let deepLinkId = deepLinkReceiptId {
//                navigateToReceiptId = deepLinkId
//                deepLinkReceiptId = nil
//            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .openReceiptDetail)) { notification in
            if let receiptId = notification.userInfo?["receiptId"] as? String {
                handleDeepLink(receiptId)
            }
        }
        .sheet(item: $navigateToReceipt) { receipt in
            BillDetailsView(rviewModel: rviewModel, receipt: receipt)
        }
    }
    
    private func handleDeepLink(_ receiptId: String) {
        Task {
            if let receipt = await rviewModel.getReceipt(id: receiptId) {
                DispatchQueue.main.async {
                    self.navigateToReceipt = receipt
                    //self.selectedTab = 0 // Switch to Home tab
                }
            } else {
                print("Receipt not found for ID: \(receiptId)")
            }
        }
    }
    
}

