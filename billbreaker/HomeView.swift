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
    
    @ObservedObject var rviewModel: ReceiptViewModel
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    
    let customLinkColor = Color(hex: "#30cd31")
    
    init(rviewModel: ReceiptViewModel) {
        self.rviewModel = rviewModel
    }
    
    var body: some View {
        //NavigationStack(path: $router.receiptPath) {
            ReceiptListView(rviewModel: rviewModel)
                .foregroundColor(customLinkColor)
                .navigationTitle("My Checks")
                .toolbar {
                    HomeToolbar(
                        onEdit: rviewModel.handleEdit,
                        onJoin: { showingJoinSheet = true },
                        onAdd: { showingNewReceiptSheet = true }
                    )
                }
//                .navigationDestination(for: ReceiptRoute.self) { route in
//                    switch route {
//                    case .details(let receiptId):
//                        BillDetailsView(rviewModel: rviewModel, receiptId: receiptId)
//                    }
//                }
        //}
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
    }
}

