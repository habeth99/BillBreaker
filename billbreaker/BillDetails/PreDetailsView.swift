//
//  PreDetailsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 9/7/24.
//

import Foundation
import SwiftUI

//struct PreDetailsView: View {
//    @ObservedObject var rviewModel: ReceiptViewModel
//    var receiptId: String
//    
//    @EnvironmentObject var viewModel: UserViewModel
//    
//    var body: some View {
//        VStack {
//            Text("Who are you?")
//            ForEach(rviewModel.receipt.people!, id: \.id) { person in
//                Button(action: {
//                    rviewModel.selectedPerson = person
//                }) {
//                    Text(person.name)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(rviewModel.selectedPerson.id == person.id ? person.color : Color.clear)
//                        .foregroundColor(rviewModel.selectedPerson.id == person.id ? .white : .primary)
//                        .cornerRadius(8)
//                }
//            }
//        }
//        .onAppear {
//            rviewModel.setReceipt(receiptId: receiptId)
//        }
//    }
//}
