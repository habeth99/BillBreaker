//
//  AddPeopleView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/8/24.
//

import Foundation
import SwiftUI

import SwiftUI

//struct AddPeopleView: View {
//    @State private var guests: [String] = [""]
//
//    var body: some View {
//        VStack {
//            
//                ForEach(0..<guests.count, id: \.self) { index in
//                    TextField("Guest \(index + 1)", text: $guests[index])
//                }
//                
//                if guests.count < 10 {
//                    Button(action: addGuest) {
//                        Text("Add Guest")
//                    }
//                }
//
//        }
//    }
//
//    private func addGuest() {
//        if guests.count < 10 {
//            guests.append("")
//        } else {
//            print("Max reached no more guests can be added")
//        }
//    }
//}
//struct AddPeopleView: View {
//    @State private var guests: [String] = [""]
//    
//    var body: some View {
//        VStack {
//            ForEach(0..<guests.count, id: \.self) { index in
//                TextField("Guest \(index + 1)", text: $guests[index])
//                    .font(.system(size: 18))
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray, lineWidth: 1)
//                    )
//                    .background(Color.white)
//            }
//            
//            if guests.count < 10 {
//                Button(action: addGuest) {
//                    Text("Add Guest")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//            }
//        }
//        .cornerRadius(15)
//    }
//    
//    private func addGuest() {
//        if guests.count < 10 {
//            guests.append("")
//        } else {
//            print("Max reached no more guests can be added")
//        }
//    }
//}
struct AddPeopleView: View {
    @State private var guests: [String] = [""]
    
    var body: some View {
        VStack(spacing: 10) {  // Add some spacing between elements
            ForEach(0..<guests.count, id: \.self) { index in
                TextField("Guest \(index + 1)", text: $guests[index])
                    .font(.system(size: 18))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            if guests.count < 10 {
                Button(action: addGuest) {
                    Text("Add Guest")
                        .foregroundColor(.white)
//                        .frame(width: 395, height: 55)
                        .padding()
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical)
            }
        }
//        .padding()  // Add padding around the VStack
//        .background(Color.gray.opacity(0.1))  // Light gray background
        .cornerRadius(15)
    }
    
    private func addGuest() {
        if guests.count < 10 {
            guests.append("")
        } else {
            print("Max reached no more guests can be added")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddPeopleView()
    }
}
