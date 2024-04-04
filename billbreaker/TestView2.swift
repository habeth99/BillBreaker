//
//  TestView2.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/4/24.
//

import Foundation
import SwiftUI

struct TestView2: View {
    let billName: String
    
    // Add `isSelected` to `BillItem` to track selection state for each item.
    struct BillItem: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let price: Double
        var isSelected = false
    }
    
    struct Person: Identifiable, Hashable {
        let id = UUID()
        let name: String
        var selectedItems: [BillItem] // Store selected items for each person
    }
    
    // ObservableObject to hold the state of each person and their selected items
    class BillViewModel2: ObservableObject {
        @Published var people: [Person]
        @Published var showingSheet = false
        @Published var selectedPerson: Person?
        
        init(people: [Person]) {
            self.people = people
        }
    }
    
    @StateObject var viewModel: BillViewModel2
    
    // The list of food items is now part of the ViewModel, so it can be shared by the sheet
    @State private var billItems: [BillItem] = [
        BillItem(name: "Chicken Burrito", price: 8.99),
        // Add more items as needed
    ]
    
    var body: some View {
        ScrollView {
            VStack {
                foodSection
                peopleSection
            }
        }
        .navigationBarTitle(billName, displayMode: .inline)
        .background(Color.gray.opacity(0.2))
        .sheet(isPresented: $viewModel.showingSheet) {
            if let selectedPerson = viewModel.selectedPerson {
                PersonSelectionSheet(person: selectedPerson, billItems: $billItems) { selectedItems in
                    if let index = viewModel.people.firstIndex(where: { $0.id == selectedPerson.id }) {
                        viewModel.people[index].selectedItems = selectedItems
                    }
                }
            }
        }
    }
    
    var foodSection: some View {
        VStack(alignment: .leading) {
            Text("Food")
                .fontWeight(.heavy)
                .font(.system(size: 36))
                .padding()
            
            ForEach(billItems, id: \.self) { item in
                HStack {
                    Text(item.name)
                        .padding()
                    Spacer()
                    Text(String(format: "$%.2f", item.price))
                        .padding()
                }
            }
        }
    }
    
    var peopleSection: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("People")
                .fontWeight(.heavy)
                .font(.system(size: 36))
                .padding()
            ForEach(viewModel.people, id: \.self) { person in
                VStack {
                    Text(person.name).font(.headline)
                        .padding()
                }
                .frame(width: 346, height: 175)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 1)
                .onTapGesture {
                    viewModel.selectedPerson = person
                    viewModel.showingSheet = true
                }
            }
        }
    }
}

struct PersonSelectionSheet: View {
    let person: TestView2.Person
    @Binding var billItems: [TestView2.BillItem]
    let onSelectionDone: ([TestView2.BillItem]) -> Void
    
    var body: some View {
        NavigationView {
            List {
                ForEach($billItems) { $item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text(String(format: "$%.2f", item.price))
                    }
                    .onTapGesture {
                        item.isSelected.toggle()
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .background(item.isSelected ? Color.blue : Color.clear)
                }
            }
            .navigationBarTitle(Text(person.name), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        onSelectionDone(billItems.filter { $0.isSelected })
                    }
                }
            }
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

// To define a preview provider for SwiftUI previews
struct TestView2_Previews: PreviewProvider {
    static var previews: some View {
        let people = [
            TestView2.Person(name: "Gary", selectedItems: []),
            // Add more people as needed
        ]
        return NavigationView { // Wrap in a NavigationView for the preview
            TestView2(billName: "Example", viewModel: TestView2.BillViewModel2(people: people))
        }
    }
}

