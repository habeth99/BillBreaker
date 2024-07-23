//
//  JoinReceiptView.swift
//  billbreaker
//
//  Created by Nick Habeth on 6/12/24.
//

import Foundation
import SwiftUI


struct JoinReceiptView: View {
    @Binding var isPresented: Bool // Use this to dismiss the sheet
    @State private var receiptId = ""
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter Receipt ID", text: $receiptId)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    rviewModel.joinReceiptWith(receiptId: receiptId) { success in
                        if success {
                            print("Receipt saved successfully.")
                            let userId = rviewModel.userViewModel.currentUser?.id
                            rviewModel.addReceiptToUser2(receiptId: receiptId) { success in
                                if success {
                                    print("Receipt added to user successfully!")
                                    isPresented = false // Dismiss the sheet
                                } else {
                                    print("Error adding receipt to user.")
                                }
                            }
                        } else {
                            print("Failed to fetch the receipt.")
                        }
                    }
                }, label: {
                    Text("Join")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                })
                .padding()
                
                Spacer()
            }
            .navigationTitle("Join Receipt")
            .navigationBarItems(leading: cancelButton)
            .padding()
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
}
