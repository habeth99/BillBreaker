//
//  AddPeopleView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/8/24.
//

import Foundation
import SwiftUI

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
            
            AddButton(action: addGuest)
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
