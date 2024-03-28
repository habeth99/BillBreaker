//
//  HomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/28/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var bills = ["Bill 1", "Bill 2"]
    @State private var showActionSheet = false
    @State private var showingCreateBillSheet = false
    @State private var newBillTitle = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(bills, id: \.self) { bill in
                    NavigationLink(destination: BillDetailView(billName: bill)) {
                        Text(bill)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My Bills")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("What would you like to do?"),
                    buttons: [
                        .default(Text("Create New Bill")) { self.showingCreateBillSheet = true },
                        .default(Text("Join Bill")) { self.joinBill() },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingCreateBillSheet) {
                NavigationView {
                    Form {
                        TextField("Title", text: $newBillTitle)
                        Button("Add Bill") {
                            self.addBill(title: self.newBillTitle)
                            self.newBillTitle = "" // Reset title
                            self.showingCreateBillSheet = false // Dismiss sheet
                        }
                        .disabled(newBillTitle.isEmpty)
                    }
                    .navigationTitle("New Bill")
                    .navigationBarItems(trailing: Button("Cancel") {
                        self.showingCreateBillSheet = false
                    })
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        bills.remove(atOffsets: offsets)
    }
    
    func addBill(title: String) {
        bills.append(title)
    }
    
    func joinBill() {
        // Placeholder for join bill logic
        print("Joining an existing bill...")
    }
}

struct BillDetailView: View {
    let billName: String
    
    var body: some View {
        Text("Details for \(billName)")
            .navigationTitle(billName)
    }
}



#Preview {
    HomeView()
}
