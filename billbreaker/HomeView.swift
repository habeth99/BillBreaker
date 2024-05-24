//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

//import Foundation
//import SwiftUI
//
//struct HomeView: View {
//    @State private var bills = ["Bill 1"]
//    @State private var showActionSheet = false
//    @State private var showingNewReceiptSheet = false
//    @State private var newBillTitle = ""
//    @EnvironmentObject var viewModel: UserViewModel
//    //@StateObject private var rviewModel: ReceiptViewModel
//
//    
//    
//    var body: some View {
//        TabView {
//            NavigationView {
//                VStack {
//                    //Text("\(self.viewModel.userReceipts.isEmpty)")
//                    List {
//                        ForEach(bills, id: \.self) { bill in
//                            NavigationLink(destination: BillDetailsView()) {
//                                Text("Chipotle")
//                                // Text(viewModel.receipt.name)
//                            }
//                        }
//                        //.onDelete(perform: deleteItems)
//                    }
//                    .navigationTitle("My Receipts")
//                    .toolbar {
//                        ToolbarItemGroup(placement: .navigationBarLeading) {
//                            Button(action: {
//                                print("edit Button was tapped")
//                            }) {
//                                Text("Edit")
//                            }
//                        }
//                        
//                        ToolbarItemGroup(placement: .navigationBarTrailing) {
//                            Button(action: {
//                                print("add Button was tapped")
//                                showingNewReceiptSheet = true
//
//                            }) {
//                                Image(systemName: "plus")
//                            }
//                        }
//                    }
//                    .sheet(isPresented: $showingNewReceiptSheet) {
//                        //_rviewModel = ReceiptViewModel(receipt: Receipt(), userViewModel: viewModel)
//                        NewReceiptView(isPresented: $showingNewReceiptSheet, rviewModel: ReceiptViewModel( user: viewModel))
//                    }
//                }
//            }
//            .tabItem {
//                Label("Home", systemImage: "house")
//            }
//                
//            ProfileView()
//            .tabItem {
//                Label("Profile", systemImage: "person")
//            }
//        }
//    }
//}


//#Preview {
//    HomeView()
//}

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var bills = ["Bill 1"]
    @State private var showActionSheet = false
    @State private var showingNewReceiptSheet = false
    @State private var newBillTitle = ""
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    if viewModel.userReceipts.isEmpty {
                        Text("No Receipts Available")
                            .padding()
                    } else {
                        List(viewModel.userReceipts) { receipt in
                            NavigationLink(destination: BillDetailsView()) {
                                VStack(alignment: .leading) {
                                    Text(receipt.name)
                                        .font(.headline)
                                    Text("Date: \(receipt.date)")
                                        .font(.subheadline)
                                    Text("Total: $\(receipt.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                            }
                        }
                        .navigationTitle("My Receipts")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarLeading) {
                                Button(action: {
                                    print("edit Button was tapped")
                                }) {
                                    Text("Edit")
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
                    }
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
        .onAppear {
            print("HomeView appeared")
            viewModel.fetchUser()// Fetch user data when the view appears
            print("User: \(String(describing: viewModel.currentUser))")
            print("User Receipts: \(viewModel.userReceipts)")
        }
    }
}

