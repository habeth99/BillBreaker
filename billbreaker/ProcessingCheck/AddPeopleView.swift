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
                List {
                    ForEach(guests.indices, id: \.self) { index in
                        guestTextField(index: index)
                    }
                    .onDelete(perform: deleteGuests)
                }
                .navigationBarItems(
                    trailing: Button("Next") {
                        transformer.createLegitPs(guests: guests)
                        router.navigateInScanFlow(to: .review)
                    }
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
        guests.append("")
    }
    
    private func deleteGuests(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
        if guests.isEmpty {
            guests = [""]
        }
    }
}


