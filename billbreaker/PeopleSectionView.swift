//
//  PeopleSectionView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct PeopleSectionView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    private func formattedCurrency(_ amount: Decimal) -> String {
        return currencyFormatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$0.00"
    }
    
    var body: some View {
        ForEach(rviewModel.receipt.people ?? [], id: \.id) { person in
            //Section {
                personDetails(for: person)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(32)
                    .background(Color.white)
                    .cornerRadius(8)
                    .contentShape(Rectangle())
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        rviewModel.selectPerson(person)
                    }
            //}
//            .listRowInsets(EdgeInsets())
//            .listRowBackground(Color.blue)
//            .swipeActions {
//                Button(role: .destructive) {
//                    rviewModel.receipt.deletePerson(id: person.id)
//                    rviewModel.saveReceipt { success in
//                        if success {
//                            print("Receipt saved successfully")
//                        } else {
//                            print("Failed to save receipt")
//                        }
//                    }
//                } label: {
//                    Label("Delete", systemImage: "trash")
//                }
//            }
        }
    }
    
    private func personDetails(for person: LegitP) -> some View {
        let itemsWithPrice: [(Item, Decimal)] = person.claims.compactMap { claimID in
            if let item = rviewModel.receipt.findItemById(id: claimID) {
                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
                let sharePrice = item.price / Decimal(numberOfClaimants)
                return (item, sharePrice)
            }
            return nil
        }
        
        let personTotal: Decimal = itemsWithPrice.reduce(into: Decimal.zero) { $0 += $1.1 }
        let receiptTotal: Decimal = rviewModel.receipt.items?.reduce(into: Decimal.zero) { $0 += $1.price } ?? 0.0
        
        let personPercentage = personTotal / receiptTotal
        
        let tipAmount = rviewModel.receipt.tip ?? Decimal.zero
        let taxAmount = rviewModel.receipt.tax ?? Decimal.zero
        
        let personTipShare = tipAmount * personPercentage
        let personTaxShare = taxAmount * personPercentage
        
        let total = personTotal + personTipShare + personTaxShare

        return HStack(alignment: .top, spacing: FatCheckTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: FatCheckTheme.Spacing.xs) {
                HStack{
                    Circle()
                        .fill(person.color)
                        .frame(width: 19, height: 19)
                    Text(person.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
                    HStack {
                        Text(item.name)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .font(.subheadline)
                        Spacer()
                        Text(formattedCurrency(sharePrice))
                            .font(.subheadline)
                    }
                }
                HStack {
                    Text("Tip")
                    Spacer()
                    Text(formattedCurrency(personTipShare))
                }
                .font(.subheadline)
                HStack {
                    Text("Tax")
                    Spacer()
                    Text(formattedCurrency(personTaxShare))
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: FatCheckTheme.Spacing.xs) {
                Text(formattedCurrency(total))
                    .font(.title)
                    .fontWeight(.bold)
                Text("Total")
                    .font(.subheadline)
                Button(action: { payUp(total: total) }) {
                    Text("Request")
                        .foregroundColor(FatCheckTheme.Colors.white)
                        .font(.subheadline)
                        .padding(8)
                        .frame(minWidth: 100)
                        .background(FatCheckTheme.Colors.primaryColor)
                        .cornerRadius(FatCheckTheme.Spacing.xs)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func payUp(total: Decimal) {
        let payViewModel = PayBack()
        //payViewModel.fetchVenmoHandle(forUserID: rviewModel.receipt.userId) { venmoHandle in
            //if let venmoHandle = venmoHandle {
                // Use the venmoHandle to initiate the payment
                //print("Venmo handle for payment: \(venmoHandle)")
                // actually opens the venmo app
                //payViewModel.requestVenmo(recipient: venmoHandle, amount: "\(total)")
        payViewModel.requestVenmo(amount: "\(total)")
            //} else {
                //print("Could not fetch Venmo handle for user")
            //}
        //}
    }
}

