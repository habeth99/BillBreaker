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
    @State private var participants = [String](repeating: "", count: 1) // Start with one empty participant

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
                        self.showActionSheet = true // Trigger the action sheet
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .actionSheet(isPresented: $showActionSheet) { // Present the action sheet
                //action sheet
                ActionSheet(
                    title: Text("What would you like to do?"),
                    buttons: [
                        .default(Text("Create New Bill")) { self.resetCreateBillForm(); self.showingCreateBillSheet = true },
                        .default(Text("Join Bill")) { self.joinBill() },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingCreateBillSheet) { // Present the create bill sheet
                NavigationView {
                    Form {
                        TextField("Title", text: $newBillTitle)
                        
                        Section(header: Text("Participants")) {
                            ForEach(0..<participants.count, id: \.self) { index in
                                TextField("Name", text: $participants[index])
                                    .onChange(of: participants[index]) { _ in
                                        if index == participants.count - 1 && participants.count < 20 {
                                            participants.append("") // Add new field if the last one is being edited
                                        }
                                    }
                            }
                            .onDelete { indices in
                                participants.remove(atOffsets: indices)
                            }
                        }
                        
                        Button("Add Bill") {
                            self.addBill(title: self.newBillTitle, participants: self.participants.filter { !$0.isEmpty })
                            self.resetCreateBillForm()
                            self.showingCreateBillSheet = false // Dismiss sheet
                        }
                        .disabled(newBillTitle.isEmpty || participants.allSatisfy { $0.isEmpty })
                    }
                    .navigationTitle("New Bill")
                    .navigationBarItems(trailing: Button("Cancel") {
                        self.resetCreateBillForm()
                        self.showingCreateBillSheet = false
                    })
                }
            }
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        bills.remove(atOffsets: offsets)
    }
    
    func addBill(title: String, participants: [String]) {
        // Logic to add a new bill with the specified title and participants
        bills.append(title) // Simplified for this example
    }
    
    func joinBill() {
        // Placeholder for join bill logic
        print("Joining an existing bill...")
    }
    
    func resetCreateBillForm() {
        newBillTitle = ""
        participants = [""]
    }
}



#Preview {
    HomeView()
}
