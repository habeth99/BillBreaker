//
//  HorizontalNameView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI

struct HorizontalScrollView: View {
    @State private var names = ["Alice", "Bob", "Charlie", "Diana", "Evan", "Fiona", "George"]
    @State private var showingSheet = false
    @State private var newName = ""

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(names, id: \.self) { name in
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                            
                            Text(name)
                                .foregroundColor(.black)
                        }
                        .frame(width: 70, height: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    Button(action: {
                        // Action to show sheet or another view for entering the name
                        showingSheet = true
                    }) {
                        Text("Add Person")
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .frame(width: 95, height: 100) // Specify the frame for the button
                    .background(Color.white) // Apply background after setting the frame
                    .cornerRadius(10)
                    .shadow(radius: 2) // Apply shadow last to affect the entire button appearance
                    .padding(.trailing, 10)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingSheet) {
            // Present a simple form to enter a new name
            NameEntryView(newName: $newName, names: $names)
        }
    }
}

struct NameEntryView: View {
    @Binding var newName: String
    @Binding var names: [String]
    
    var body: some View {
        VStack {
            TextField("Enter name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Add") {
                names.append(newName)
                newName = "" // Clear the text field
            }
            .padding()
         
        }
        .padding()
    }
}


#Preview {
    HorizontalScrollView()
}

