//
//  NewReceiptSheet.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/8/24.
//

import Foundation
import SwiftUI

//THIS IS A SHEET
struct NewReceiptView: View {
    @Binding var isPresented: Bool // Use this to dismiss the sheet
    @State var showingEnterItemsView: Bool = false
    @State private var name = ""
    @State private var people: [String] = [""]
    @State private var items: [String] = [""]
    
    
    
    // Add any other properties or bindings you need to pass into this view
    
    var body: some View {
        NavigationView {
            List{
                TextField("Enter restaurant name", text: $name)
                
                    ForEach(people.indices, id: \.self) {index in
                        TextField("Enter participant name", text: Binding(
                            get: { people[index] },
                            set: { newValue in
                                people[index] = newValue
                                // Auto-append a new empty field when typing in the last TextField
                                if index == people.count - 1 && !newValue.isEmpty {
                                    people.append("")
                                }
                            }
                        ))
                    }
                
//                ForEach(items.indices, id: \.self) {index in
//                    TextField("Enter item name", text: Binding(
//                        get: { items[index] },
//                        set: { newValue in
//                            items[index] = newValue
//                            // Auto-append a new empty field when typing in the last TextField
//                            if index == items.count - 1 && !newValue.isEmpty {
//                                items.append("")
//                            }
//                        }
//                    ))
//                }
                
                Button(action: {
                    print("Next Button tapped")
                    showingEnterItemsView = true
                }) {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the button's frame
                }
                .sheet(isPresented: $showingEnterItemsView) {
                    EnterItemsView(isPresented: $showingEnterItemsView)
                }
                .padding() // Padding around the entire button
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                )
                .frame(width: 315, height: 85) 
            }
            .navigationTitle("New Receipt")
            .navigationBarItems(leading: Button("Cancel") {
                // Dismiss the sheet
                isPresented = false
            })
        }
    }
}
