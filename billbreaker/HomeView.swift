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
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    @State private var cancellables = Set<AnyCancellable>()
    
    let customLinkColor = Color(hex: "#30cd31")
    
    init(rviewModel: ReceiptViewModel) {
        self.rviewModel = rviewModel
    }
    
    var body: some View {
        ZStack {
            if rviewModel.receiptList.isEmpty {
                EmptyStateView()
            } else {
                ReceiptListView(rviewModel: rviewModel)
                    .foregroundColor(customLinkColor)
            }
            
            AddButton(action: {
                router.navBackToCamera()
            })
        }
        .navigationTitle("My Checks")
        .sheet(isPresented: $showingNewReceiptSheet) {
            NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel())
        }
        .onAppear {
            print("Homeview appears")
            Task {
                await rviewModel.fetchUserReceipts()
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 60))
            
            Text("No Checks")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your history of fatchecks will be shown here.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

