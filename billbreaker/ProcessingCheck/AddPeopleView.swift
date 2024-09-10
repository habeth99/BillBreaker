//
//  AddPeopleView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/8/24.
//

import Foundation
import SwiftUI

struct AddPeopleView: View {
    @State private var guests: [String]
    @State private var errorMessage: String?
    @State private var errorMessage2: String?
    private let maxGuests = 10
    var transformer: ReceiptProcessor
    @EnvironmentObject var router: Router
    
    init(userName: String, transformer: ReceiptProcessor) {
        //self._guests = State(initialValue: [userName])
        self._guests = State(initialValue: [userName, ""])
        self.transformer = transformer
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top)
                        .padding(.horizontal)
                }
                if let errorMessage2 = errorMessage2 {
                    Text(errorMessage2)
                        .foregroundColor(.red)
                        .padding(.top)
                        .padding(.horizontal)
                }
                
                List {
                    ForEach(guests.indices, id: \.self) { index in
                        guestTextField(index: index)
                    }
                    .onDelete(perform: deleteGuests)
                }
                .navigationBarItems(
                    trailing: Button("Next", action: next)
                )
                .navigationBarTitle("Add Friends", displayMode: .inline)
            }
            
            VStack {
                Spacer()
                AddButton(action: addGuest)
            }
        }
    }
    
    private func guestTextField(index: Int) -> some View {
        TextField("Friend \(index - 1 + 1)", text: $guests[index])
            .padding(.vertical, FatCheckTheme.Spacing.xs)
    }
    
    private func addGuest() {
        guard guests.count < maxGuests else {
            print("Maximum number of guests reached")
            return
        }
        
        if let lastGuest = guests.last, !lastGuest.isEmpty {
            guests.append("")
        } else {
            errorMessage2 = "fill in name before adding more friends."
        }
    }
    
    private func deleteGuests(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
        if guests.isEmpty {
            guests = [""]
        }
    }
    
    private func next() {
        let nonEmptyGuests = guests.filter { !$0.isEmpty }
        
        if nonEmptyGuests.count >= 2 {
            errorMessage = nil // Clear any previous error message
            transformer.createLegitPs(guests: guests)
            router.navigateInScanFlow(to: .review)
        } else {
            errorMessage = "Please add at least one friend to continue."
        }
    }
}


