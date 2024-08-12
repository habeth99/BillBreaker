//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI
import Combine

struct HomeView: View {
    @State private var showingNewReceiptSheet = false
    @State private var showingJoinSheet = false
    @State private var editing = false
    
    @ObservedObject var rviewModel: ReceiptViewModel
    //@ObservedObject var hviewModel: HomeViewModel
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    @State private var cancellables = Set<AnyCancellable>()
    
    let customLinkColor = Color(hex: "#30cd31")
    
    init(rviewModel: ReceiptViewModel) {
        self.rviewModel = rviewModel
    }
    
    var body: some View {
        ReceiptListView(rviewModel: rviewModel)
//            .background(FatCheckTheme.Colors.accentColor)
            .foregroundColor(customLinkColor)
            .navigationTitle("My Checks")
            .toolbar {
                HomeToolbar(
                    onEdit: { editing = true },
                    onJoin: { showingJoinSheet = true },
                    onAdd: { showingNewReceiptSheet = true }
                )
            }
            .sheet(isPresented: $showingNewReceiptSheet) {
                NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel())
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

