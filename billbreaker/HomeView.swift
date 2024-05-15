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
    @State private var newBillTitle = ""
    @EnvironmentObject var rviewModel: ReceiptViewModel
    @EnvironmentObject var viewModel: UserViewModel
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(bills, id: \.self) { bill in
                        NavigationLink(destination: BillDetailsView()) {
                            Text("Chipotle")
                            // Text(viewModel.receipt.name)
                        }
                    }
                    //.onDelete(perform: deleteItems)
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
                    NewReceiptView(isPresented: $showingNewReceiptSheet)
                }
                
                
                NavigationLink(destination: ProfileView()) {
                    Text("Profile")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    viewModel.signOut()
                }, label: {
                    Text("Sign Out")
                })
                
                Button(action: {
                    viewModel.printCurrentUserId()
                }, label: {
                    Text("User is")
                })
            }
        }
    }
}


#Preview {
    HomeView()
}
