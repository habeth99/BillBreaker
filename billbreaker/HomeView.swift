//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var bills = ["Bill 1"]
    @State private var showActionSheet = false
    @State private var showingNewReceiptSheet = false
    @State private var showingJoinSheet = false
    @State private var newBillTitle = ""
    @StateObject private var rviewModel: ReceiptViewModel
    @EnvironmentObject var viewModel: UserViewModel
    
    init(viewModel: UserViewModel) {
        self._rviewModel = StateObject(wrappedValue: ReceiptViewModel(user: viewModel))
        //self.rviewModel.fetchUserReceipts()
    }
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                        List(Array(rviewModel.receiptList.enumerated()), id: \.element.id) { (index, receipt) in
                            NavigationLink(destination: BillDetails2View(rviewModel: rviewModel, receipt: receipt)) {
                                VStack(alignment: .leading) {
                                    Text(receipt.name)
                                        .font(.headline)
                                    Text("Date: \(receipt.date)")
                                        .font(.subheadline)
                                    Text("Total: $\(receipt.getTotal(), specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .navigationTitle("My Checks")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button(action: {
                                    print("edit Button was tapped")
                                }) {
                                    Text("Edit")
                                }
                            }
                            
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button(action: {

                                    showingJoinSheet = true
                                    
                                }) {
                                    Text("Join")
                                }
                            }
                            
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button(action: {
                                    print("add Button was tapped")
                                    showingNewReceiptSheet = true
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        .sheet(isPresented: $showingNewReceiptSheet) {
                            NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel(user: viewModel))
                        }
                        .sheet(isPresented: $showingJoinSheet) {
                            //JoinReceiptView(isPresented: $showingJoinSheet, rviewModel: ReceiptViewModel(user: viewModel))
                            JoinReceiptView(isPresented: $showingJoinSheet, rviewModel: rviewModel)
                        }
                    }
//                    .onAppear {
//                        print("HomeView appeared")
//                        rviewModel.fetchUserReceipts()// Fetch user data when the view appears
//                        print("User: \(String(describing: viewModel.currentUser))")
//                        print("User Receipts: \(rviewModel.receiptList)")
//                    }
                    .task {
                        await rviewModel.fetchUserReceipts()
                        print("User: \(String(describing: viewModel.currentUser))")
                        print("User Receipts: \(rviewModel.receiptList)")
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

