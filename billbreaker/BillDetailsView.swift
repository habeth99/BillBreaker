//
//  HomeView21.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import SwiftUI

struct BillDetailsView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receipt: Receipt

    var body: some View {
        ZStack {
            // Make background gray
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // MARK: Header
                    Text("Items")
                        .font(.title)
                        .fontWeight(.bold)
                    itemsSection
                    peopleSection

                    if let selectedPerson = rviewModel.selectedPerson {
                        claimedItemsSection(for: selectedPerson)
                    }
                }
                .padding(EdgeInsets(top: 30, leading: 19, bottom: 0, trailing: 24))
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        Text(receipt.date) // Your date here
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 100)
                }
            }
        }
        .navigationBarTitle(receipt.name, displayMode: .automatic)
        .onAppear {
            // set receipt variable
            rviewModel.setReceipt(receipt: receipt)
        }
    }

    // Items section
    private var itemsSection: some View {
        VStack(alignment: .leading) {
            ForEach(receipt.items ?? [], id: \.id) { item in
                HStack {
                    Text(item.name)
                        .padding()
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                        .padding()
                }
                .background(rviewModel.selectedItems.contains(where: { $0.id == item.id }) ? Color.blue.opacity(0.3) : Color.clear)
                .onTapGesture {
                    if rviewModel.selectedPerson != nil {
                        rviewModel.toggleItemSelection(item)
                    } else {
                        print("No person selected")
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .frame(width: 361)
        .shadow(radius: 1)
    }

    // People section
    private var peopleSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("People")
                .padding(EdgeInsets(top: 25, leading: 0, bottom: -1, trailing: 0))
                .fontWeight(.bold)
                .font(.title)

            ForEach(receipt.people ?? [], id: \.id) { person in
                PeopleView(rviewModel: rviewModel, person: person, isSelected: rviewModel.selectedPerson?.id == person.id)
                    .onTapGesture {
                        rviewModel.selectPerson(person)
                    }
            }
        }
    }

    // Claimed items section
    private func claimedItemsSection(for person: LegitP) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(person.name)'s Claimed Items")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(person.claims, id: \.id) { item in
                HStack {
                    Text(item.name)
                        .padding()
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                        .padding()
                }
                .background(Color.green.opacity(0.3))
                .cornerRadius(8)
                .shadow(radius: 1)
            }
        }
        .padding(.top, 20)
    }
}

// Helper view to display each person
struct PeopleView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @ObservedObject var person: LegitP
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(person.name)
                    .padding([.top, .leading])
                    .fontWeight(.bold)
                Spacer()
            }
            Spacer()
        Text("Claims:")
                .padding([.leading])
            ForEach(person.claims, id: \.id) { item in
                HStack {
                    Text(item.name)
                    Text(String(format: "$%.2f", item.price))
                }
                .padding([.leading, .trailing])
            }
                Text("Total: \(rviewModel.personTotal())")
                .padding([.leading])
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 150) // Adjust the size of the people view
        .background(isSelected ? Color.blue.opacity(0.3) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

// Preview
struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockItems = [
            Item(id: "1", name: "Item 1", price: 10.0),
            Item(id: "2", name: "Item 2", price: 15.0),
            Item(id: "3", name: "Item 3", price: 20.0)
        ]
        
        let mockPeople = [
            LegitP(id: "1", name: "John", claims: [mockItems[0]]),
            LegitP(id: "2", name: "Jane", claims: [mockItems[1]]),
            LegitP(id: "3", name: "Joe", claims: [mockItems[2]])
        ]
        
        let mockReceipt = Receipt(id: "1", userId: "user1", name: "Test Receipt", date: "2024-05-28", createdAt: "12:00 PM", tax: 2.0, price: 45.0, items: mockItems, people: mockPeople)
        
        let mockViewModel = ReceiptViewModel(user: UserViewModel())
        mockViewModel.receipt = mockReceipt
        
        return BillDetailsView(rviewModel: mockViewModel, receipt: mockReceipt)
            .environmentObject(UserViewModel())
    }
}








