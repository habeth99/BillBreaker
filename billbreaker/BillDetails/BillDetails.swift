//
//  NewBillDetails.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/2/24.
//

import Foundation
import SwiftUI

struct BillDetailsView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receiptId: String
    @State private var isEditingTip = false
    @State private var isEditingTax = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            List {

                Section(header: Text("Items"), footer:
                    HStack {
                        Spacer()
                        Button(action: addItemm) {
                            Text("Add item")
                                .padding(.top, FatCheckTheme.Spacing.xs)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                ) {
                    ItemsSectionView(rviewModel: rviewModel)
                }
                //.listRowInsets(EdgeInsets())
                
                Section(header: Text("Tip and Tax")) {
                    EditableTipView(
                        tipAmount: rviewModel.receipt.tip,
                        isEditing: $isEditingTip,
                        onEndEdit: { updatedTip in
                            rviewModel.updateTip(updatedTip)
                        }
                    )
                    EditableTaxView(
                        taxAmount: rviewModel.receipt.tax,
                        isEditing: $isEditingTax,
                        onEndEdit: { updatedTax in
                            rviewModel.updateTax(updatedTax)
                        }
                    )
                    
                }
                
                Section(header: Text("Friends").padding(.leading, FatCheckTheme.Spacing.md).padding(.vertical, FatCheckTheme.Spacing.xs)
                    .padding(.top, FatCheckTheme.Spacing.sm)
                        , footer:
                    HStack {
                        Spacer()
                        Button(action: adFren) {
                            Text("Add friend")
                                .padding(FatCheckTheme.Spacing.sm)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                ) {
                    PeopleSectionView(rviewModel: rviewModel)
                        .listRowSeparator(.automatic)
                }
                .listRowInsets(EdgeInsets())
                
            }
        }
        .navigationBarTitle(rviewModel.receipt.name, displayMode: .automatic)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareButtonView(rviewModel: rviewModel)
            }
        }
        .onAppear {
            rviewModel.setReceipt(receiptId: receiptId)
        }
    }
    
    func addItemm() {
        rviewModel.addItem(newItem: Item(name: "New item"))
    }
    func adFren() {
        var color = rviewModel.getRandomColor()
        var newPerson = LegitP(name: "New friend", color: color)
        rviewModel.addPerson(newPerson: newPerson)
    }
}

