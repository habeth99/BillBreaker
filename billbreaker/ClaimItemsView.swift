//
//  ClaimItemsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/5/24.
//

import Foundation
import SwiftUI

struct ClaimItemsView: View {
    let billItems: [BillItem]
    let person: Person
    @Binding var anotherValue: String
    @State private var selectedItems = Set<BillItem>() // State to track selected items

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("\(person.name) claim your items")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .padding(18)

                    VStack {
                        ForEach(billItems, id: \.self) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(String(format: "$%.2f", item.price))
                            }
                            .padding()
                            .background(selectedItems.contains(item) ? Color.blue.opacity(0.2) : Color.clear) // Highlight if selected
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation {
                                    if selectedItems.contains(item) {
                                        selectedItems.remove(item)
                                    } else {
                                        selectedItems.insert(item)
                                    }
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .frame(width: 350)
                    // ... more views if needed ...
                }
            }
        }
    }
}





