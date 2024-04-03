//
//  HorizontalNameView.swift
//  billbreaker
//
//  Created by Nick Habeth on 3/25/24.
//

import Foundation
import SwiftUI

struct HorizontalScrollView: View {
    @State private var names: [String] = []
    @State private var showingSheet = false
    @State private var newName = ""
    @State private var selectedName: String? = nil

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
                                .background(Color.gray) // Highlight selected
                                .clipShape(Circle())
                                
                            Text(name)
                                .foregroundColor(selectedName == name ? .white : .black) // Change text color when selected
                        }
                        .frame(width: 70, height: 100)
                        .background(selectedName == name ? Color.blue: Color.white) // Highlight background
                        .onTapGesture {
                            selectedName = name // Set selected name
                        }
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
            NameEntryView(newName: $newName, names: $names, showingSheet: $showingSheet)
        }
    }
}

struct NameEntryView: View {
    @Binding var newName: String
    @Binding var names: [String]
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack {
            TextField("Enter name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Add") {
                names.append(newName)
                newName = "" // Clear the text field
                showingSheet = false
            }
            .padding()
         
        }
        .padding()
    }
}


#Preview {
    HorizontalScrollView()
}

