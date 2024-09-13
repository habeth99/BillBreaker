//
//  NewBillDetails.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/2/24.
//

import Foundation
import SwiftUI

//struct BillDetailsView: View {
//    @ObservedObject var rviewModel: ReceiptViewModel
//    var receiptId: String
//    
//    var body: some View {
//        ZStack {
//            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
//            
//            List {
//                Section(header: Text("Items")) {
//                    ItemsSectionView(rviewModel: rviewModel)
//                }
//                
//                Section {
//                    //EditableTipView
//                }
//                
//                Section(header: Text("Friends")) {
//                    PeopleSectionView(rviewModel: rviewModel)
//                        .listRowSeparator(.automatic)
//                }
//                .listRowInsets(EdgeInsets())
//
//            }
//        }
//        .overlay(
//            AddButton2(
//                itemAction: { print("Add Item tapped") },
//                personAction: { print("Add Person tapped") }
//            )
//            .padding(.trailing, 22)
//            .padding(.bottom, -12)
//        )
//        .navigationBarTitle(rviewModel.receipt.name, displayMode: .automatic)
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                ShareButtonView(rviewModel: rviewModel)
//            }
//        }
//        .onAppear {
//            rviewModel.setReceipt(receiptId: receiptId)
//        }
//    }
//
//}

struct BillDetailsView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    var receiptId: String
    @State private var isEditingTip = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            List {
                Section(header: Text("Items")) {
                    ItemsSectionView(rviewModel: rviewModel)
                }
                
//                Section(header: Text("Tip")) {
//                    EditableTipView(
//                        tipAmount: rviewModel.receipt.tip,
//                        isEditing: isEditingTip,
//                        onEdit: { isEditingTip = true },
//                        onEndEdit: { updatedTip in
//                            isEditingTip = false
//                            rviewModel.updateTip(updatedTip)
//                        }
//                    )
//                }
                Section(header: Text("Tip")) {
                    EditableTipView(
                        tipAmount: rviewModel.receipt.tip,
                        isEditing: $isEditingTip,
                        onEndEdit: { updatedTip in
                            rviewModel.updateTip(updatedTip)
                        }
                    )
                }
                
                Section(header: Text("Friends").padding(.leading, FatCheckTheme.Spacing.md)
                ) {
                    PeopleSectionView(rviewModel: rviewModel)
                        .listRowSeparator(.automatic)
                }
                .listRowInsets(EdgeInsets())
            }
        }
        .overlay(
            AddButton2(
                itemAction: { print("Add Item tapped") },
                personAction: { print("Add Person tapped") }
            )
            .padding(.trailing, 22)
            .padding(.bottom, -12)
        )
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
}

