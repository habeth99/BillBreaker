//
//  TestView2.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/4/24.
//

import Foundation
import SwiftUI

struct ContentView4: View {
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
    struct Person: Identifiable, Hashable {
        let id = UUID() // Unique identifier for each person
        let name: String
        // Add other properties here, such as duration and calories
    }
    let billPeople: [Person] = [
        Person(name: "Gary"),
        Person(name: "Nick"),
        Person(name: "Vince"),
        Person(name: "Mason")
        // Add more people as needed
    ]

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: Header
                    Text("Receipt")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    VStack{
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
                    .cornerRadius(20)
                    .frame(width: 350)
                    
                    VStack (alignment: .leading, spacing: 15){
                        Text("People")
                            .fontWeight(.heavy)
                            .font(.system(size: 36))
                            //.padding()
                        ForEach(billPeople, id: \.self) { person in
                            VStack(alignment: .leading) {
                                Text(person.name).font(.headline)
                                
                            }
                            .frame(width: 346, height: 175)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                        
                    }
                }
            }
        }
    }
}








// To define a preview provider for SwiftUI previews
struct TestView2_Previews: PreviewProvider {
    static var previews: some View {
        //NavigationView { // Wrap in a NavigationView for the preview
            ContentView4()
        //}
    }
}

