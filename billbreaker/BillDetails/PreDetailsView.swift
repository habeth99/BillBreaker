//
//  PreDetailsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/7/24.
//

import Foundation
import SwiftUI

struct PersonList: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        ForEach(rviewModel.receipt.people ?? [], id: \.id) { person in
            HStack {
                Text(person.name)
                Spacer()
                if rviewModel.selectedPerson?.id == person.id {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                rviewModel.selectedPerson = person
            }
        }
    }
}


struct PreDetailsView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receiptId: String
    @EnvironmentObject var router: Router
    
    var body: some View {
        List {
            Section{
                Text("Join this check from")
                    .padding(.top, 100)
                    .font(.subheadline)
                Text(rviewModel.receipt.name)
                    .font(.largeTitle)
                    .bold()
                Text("Who are you?")
                    .font(.subheadline)
            }
            .listRowBackground(Color.clear)
            .listSectionSeparator(.hidden)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            
            Section{
                PersonList(rviewModel: rviewModel)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            rviewModel.setReceipt(receiptId: receiptId)
        }
        .navigationBarItems(
            trailing: Button("Join", action: save)
        )
    }
    
    private func save() {
        rviewModel.saveReceipt{ success in
            DispatchQueue.main.async {
                if success {
                    print("successful save")
                    router.navigateToReceipt(id: receiptId)
                } else {
                    print("failed to save")
                }
            }
        }
    }
}
