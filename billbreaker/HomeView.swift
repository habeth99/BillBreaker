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
    //@State private var participants = [String](repeating: "", count: 1)
    
    //declare viewmodel variable
    @EnvironmentObject var viewModel: BillViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(bills, id: \.self) { bill in
                    NavigationLink(destination: HomeView21()) {
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
                        self.showingCreateBillSheet = true // Trigger the action sheet
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateBillSheet) { // Present the create bill sheet
                NavigationView {
                    Form {
                        //new
                        TextField("Title", text: $viewModel.newBill.restaurantName)
                        //get names
                        Section(header: Text("Participants")) {
                            ForEach(0..<viewModel.newBill.participants.count, id: \.self) { index in
                                TextField("Name", text: $viewModel.newBill.participants[index])
                                    .onChange(of: viewModel.newBill.participants[index]) { _ in
                                        if index == viewModel.newBill.participants.count - 1 && viewModel.newBill.participants.count < 20 {
                                            viewModel.newBill.participants.append("") // Add new field if the last one is being edited
                                        }
                                    }
                            }
                            .onDelete { indices in
                                viewModel.newBill.participants.remove(atOffsets: indices)
                            }
                        }
                        
                        Button("Add Bill") {
                            self.addBill(title: viewModel.newBill.restaurantName, participants: viewModel.newBill.participants.filter { !$0.isEmpty })
                            self.resetCreateBillForm()
                            self.showingCreateBillSheet = false // Dismiss sheet
                        }
                        .disabled(viewModel.newBill.restaurantName.isEmpty || viewModel.newBill.participants.allSatisfy { $0.isEmpty })
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
        viewModel.newBill.restaurantName = ""
        viewModel.newBill.participants = [""]
    }
}



#Preview {
    HomeView()
}
