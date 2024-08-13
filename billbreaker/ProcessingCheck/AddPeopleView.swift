//
//  AddPeopleView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/8/24.
//

import Foundation
import SwiftUI

//struct AddPeopleView: View {
//    @State private var guests: [String] = [""]
//    @Environment(\.presentationMode) var presentationMode
//    private let maxGuests = 10
//    @Binding var isPresented: Bool
//    @State private var showingSaveCheckView = false
//    let onDismiss: () -> Void
//    var transformer: ReceiptProcessor
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                FatCheckTheme.Colors.accentColor
//                    .ignoresSafeArea()
//                VStack {
//                    topButtons
//                    ScrollView {
//                        VStack {
//                            ForEach(guests.indices, id: \.self) { index in
//                                guestTextField(index: index)
//                            }
//                            addGuestButton
//                            cancelButton
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    private var topButtons: some View {
//        HStack {
//            Button(action: onDismiss) {
//                Text("Back")
//                    .foregroundColor(.black)
//                    .padding()
//            }
//            
//            Spacer()
//            Text("Add Friends")
//                .bold()
//            Spacer()
//            
//            Button(action: next) {
//                Text("Next")
//                    .foregroundColor(.black)
//                    .padding()
//            }
//        }
//    }
//    
//    private func guestTextField(index: Int) -> some View {
//        TextField("Guest \(index + 1)", text: $guests[index])
//            .font(.system(size: 18))
//            .padding()
//            .background(Color.white)
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
//    }
//    
//    private var addGuestButton: some View {
//        Button(action: addGuest) {
//            Text("Add Guest")
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(FatCheckTheme.Colors.primaryColor)
//                .cornerRadius(10)
//        }
//        .opacity(guests.count < maxGuests ? 1 : 0)
//        .animation(.default, value: guests.count)
//    }
//    
//    private func addGuest() {
//        guard guests.count < maxGuests else {
//            print("Maximum number of guests reached")
//            return
//        }
//        guests.append("")
//    }
//    
//    private var cancelButton: some View {
//        Button(action: cancel) {
//            Text("Cancel")
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(FatCheckTheme.Colors.primaryColor)
//                .cornerRadius(10)
//        }
//    }
//    
//    private func cancel() {
//        isPresented = false
//    }
//    
//    private func next() {
//        //function to create LegitPs based off of the names of the guests list
//        transformer.createLegitPs(guests: guests)
//
//        showingSaveCheckView = true
//    }
//}
//
//// Mock data
//extension ReceiptProcessor {
//    static var mockProcessor2: ReceiptProcessor {
//        let mockItems = [
//            Item(name: "Burger", price: 10.99),
//            Item(name: "Fries", price: 3.99),
//            Item(name: "Milkshake", price: 4.50)
//        ]
//        let mockReceipt = Receipt(items: mockItems)
//        return ReceiptProcessor()
//    }
//}
//
//struct AddPeopleView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPeopleView(
//            isPresented: .constant(true),
//            onDismiss: {},
//            transformer: ReceiptProcessor.mockProcessor2
//        )
//    }
//}

struct AddPeopleView: View {
    @State private var guests: [String] = [""]
    private let maxGuests = 10
    var transformer: ReceiptProcessor
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            FatCheckTheme.Colors.accentColor
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack {
                        ForEach(guests.indices, id: \.self) { index in
                            guestTextField(index: index)
                        }
                        addGuestButton
                        cancelButton
                    }
                    .padding(.horizontal)
                }
                .navigationBarItems(
                    trailing: Button("Next") {
                        transformer.createLegitPs(guests: guests)
                        router.navigateToItemsScanView(ScanRoute.review)
                    }
                )
                .navigationBarTitle("Add Friends", displayMode: .inline)
            }
        }
    }
    
    private func guestTextField(index: Int) -> some View {
        TextField("Guest \(index + 1)", text: $guests[index])
            .font(.system(size: 18))
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
    
    private var addGuestButton: some View {
        Button(action: addGuest) {
            Text("Add Guest")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(10)
        }
        .opacity(guests.count < maxGuests ? 1 : 0)
        .animation(.default, value: guests.count)
    }
    
    private func addGuest() {
        guard guests.count < maxGuests else {
            print("Maximum number of guests reached")
            return
        }
        guests.append("")
    }
    
    private var cancelButton: some View {
        Button(action: cancel) {
            Text("Cancel")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(10)
        }
    }
    
    private func cancel() {
        router.reset()
    }

}
