//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var showingNewReceiptSheet = false
    @State private var showingJoinSheet = false
    
    @StateObject private var rviewModel: ReceiptViewModel
    
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    
    @State private var selectedReceiptId: String?
    
    init(viewModel: UserViewModel) {
        self._rviewModel = StateObject(wrappedValue: ReceiptViewModel(user: viewModel))
    }
    
    var body: some View {
            ReceiptListView(rviewModel: rviewModel)
                .navigationTitle("My Checks")
                .toolbar {
                    HomeToolbar(
                        onEdit: rviewModel.handleEdit,
                        onJoin: { showingJoinSheet = true },
                        onAdd: { showingNewReceiptSheet = true }
                    )
                }
                .sheet(isPresented: $showingNewReceiptSheet) {
                    NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel(user: viewModel))
                }
                .sheet(isPresented: $showingJoinSheet) {
                    JoinReceiptView(isPresented: $showingJoinSheet, rviewModel: rviewModel)
                }
                .onAppear {
                    print("Homeview appears")
                    Task {
                        await rviewModel.fetchUserReceipts()
                    }
                }
                .navigationDestination(for: String.self) { route in
                    switch route {
                    case "BillDetails":
                        if let receiptId = router.selectedReceiptId {
                            BillDetailsView(rviewModel: rviewModel, receiptId: receiptId)
                        }
                    default:
                        EmptyView()
                    }
                }
    }
}

