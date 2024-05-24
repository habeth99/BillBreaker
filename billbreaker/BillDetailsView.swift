//
//  HomeView21.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import SwiftUI

struct BillDetailsView: View {
    // State variables for showing the sheet and knowing
    // if a person is selected
    //@State private var isSheetPresented = false
    @State private var selectedPerson: Person?
    @State private var anotherValue: String = "Anotha one"
    
    let billItems: [BillItem] = [
        BillItem(name: "Chicken Burrito", price: 8.99),
        BillItem(name: "Steak Bowl", price: 9.99),
        BillItem(name: "Chicken Bowl", price: 8.99),
        BillItem(name: "Barbacoa Bowl", price: 7.99),
        BillItem(name: "Lemonade", price: 2.99),
        BillItem(name: "Lemonade", price: 2.99),
        BillItem(name: "Chips", price: 3.99),
        BillItem(name: "Guacamole", price: 4.99)
        // ... more items
    ]
//    struct Person: Identifiable, Hashable {
//        let id = UUID() // Unique identifier for each person
//        let name: String
//        // Add other properties here, such as duration and calories
//    }
    let billPeople: [Person] = [
        Person(name: "Gary"),
        Person(name: "Nick"),
        Person(name: "Vince"),
        Person(name: "Mason")
        // Add more people as needed
    ]

    var body: some View {
        
            ZStack {
                //Make background gray
                Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
                ScrollView{
                    VStack(alignment: .leading, spacing: 10) {
                        // MARK: Header
                        //Text("Friday, Apr 5")
                        //.foregroundColor(.accentColor)
                        Text("Items")
                            .font(.title)
                            .fontWeight(.bold)
                        VStack (alignment: .leading){
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
                        .background(Color.white)
                        .cornerRadius(12)
                        .frame(width: 361)
                        .shadow(radius: 1)
                        
                        VStack (alignment: .leading, spacing: 15){
                            Text("People")
                                .padding(EdgeInsets(top: 25, leading: 0, bottom: -1, trailing: 0))
                                .fontWeight(.bold)
                                .font(.title)
                            //.font(.system(size: 36))
                            //.padding()
                            ForEach(billPeople) { person in
                                PersonView(person: person)
                                    .onTapGesture {
                                        selectedPerson = person
                                        
                                    }
                            }
                            
                        }
                    }
                    .padding(EdgeInsets(top: 30, leading: 19, bottom: 0, trailing: 24))
                    .sheet(item: $selectedPerson, content: {person in
                        ClaimItemsView(billItems: billItems, person: person, anotherValue: $anotherValue)
                        
                    })
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        VStack {
                            Text("Friday, Apr 5") // Your date here
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                        }
                        .frame(width: 100)
                    }
                }
                //.navigationBarTitle("Chipotle", displayMode: .automatic)
            }
            .navigationBarTitle("Chipotle", displayMode: .automatic)

    }
}



struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
            BillDetailsView()
    }
}
