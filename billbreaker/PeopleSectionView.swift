//
//  PeopleSectionView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct ForceUpdater: Equatable, Hashable {
    let update: Bool
}

struct PeopleSectionView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @State private var forceUpdate = ForceUpdater(update: false)
    
    var body: some View {
        ForEach(rviewModel.receipt.people ?? [], id: \.id) { person in
            PersonCard(person: person, rviewModel: rviewModel)
                .id(person.claims.count)
        }
        .id(forceUpdate)
        .onReceive(rviewModel.$receipt) { _ in
            forceUpdate = ForceUpdater(update: !forceUpdate.update)
        }
    }
}

struct PersonCard: View {
    let person: LegitP
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        ZStack {
            // Card content
            PersonDetails(person: person, rviewModel: rviewModel)
                .padding()
                .cornerRadius(8)
            
            // Selection indicator
            if person.id == rviewModel.selectedPerson?.id {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(FatCheckTheme.Colors.primaryColor, lineWidth: 3)
                    .padding(FatCheckTheme.Spacing.xs)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            rviewModel.selectPerson(person)
        }
        .swipeActions {
            Button(role: .destructive) {
                rviewModel.receipt.deletePerson(id: person.id)
                rviewModel.saveReceipt { success in
                    if success {
                        print("Receipt saved successfully")
                    } else {
                        print("Failed to save receipt")
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct PersonDetails: View {
    let person: LegitP
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: FatCheckTheme.Spacing.md) {
            PersonItemsList(person: person, rviewModel: rviewModel)
            Spacer()
            PersonTotalView(person: person, rviewModel: rviewModel)
        }
    }
}

struct PersonItemsList: View {
    let person: LegitP
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: FatCheckTheme.Spacing.xs) {
            PersonHeader(person: person, rviewModel: rviewModel)
            ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
                ItemRow(item: item, sharePrice: sharePrice)
            }
            AdditionalCostsRows(tipShare: personTipShare, taxShare: personTaxShare)
        }
    }
    
    private var itemsWithPrice: [(Item, Decimal)] {
        person.claims.compactMap { claimID in
            if let item = rviewModel.receipt.findItemById(id: claimID) {
                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
                let sharePrice = item.price / Decimal(numberOfClaimants)
                return (item, sharePrice)
            }
            return nil
        }
    }
    
    private var personTotal: Decimal {
        itemsWithPrice.reduce(into: Decimal.zero) { $0 += $1.1 }
    }
    
    private var receiptTotal: Decimal {
        rviewModel.receipt.items?.reduce(into: Decimal.zero) { $0 += $1.price } ?? 0.0
    }
    
    private var personPercentage: Decimal {
        personTotal / receiptTotal
    }
    
    private var personTipShare: Decimal {
        (rviewModel.receipt.tip) * personPercentage
    }
    
    private var personTaxShare: Decimal {
        (rviewModel.receipt.tax) * personPercentage
    }
}

struct PersonHeader: View {
    let person: LegitP
    @EnvironmentObject var viewModel: UserViewModel
    @ObservedObject var rviewModel: ReceiptViewModel
    @State private var isEditing = false
    @State private var editedName: String

    init(person: LegitP, rviewModel: ReceiptViewModel) {
        self.person = person
        self._editedName = State(initialValue: person.name)
        self.rviewModel = rviewModel
    }
    
    var body: some View {
        if viewModel.currentUser?.id == person.userId {
            HStack {
                Circle()
                    .fill(person.color)
                    .frame(width: 19, height: 19)
                Text("You")
                    .lineLimit(1)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        } else {
            HStack {
                Circle()
                    .fill(person.color)
                    .frame(width: 19, height: 19)
                if isEditing {
                    TextField("Enter name", text: $editedName, onCommit: {
                        isEditing = false
                        rviewModel.updatePerson(personId: person.id, editedName: editedName)
                        rviewModel.saveReceipt() { success in
                            if success {
                                print("good")
                            } else {
                                print("bad")
                            }
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title2)
                    .fontWeight(.semibold)
                } else {
                    Text(person.name)
                        .lineLimit(1)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .onTapGesture {
                            isEditing = true
                        }
                }
            }
        }
    }
}

struct ItemRow: View {
    let item: Item
    let sharePrice: Decimal
    
    var body: some View {
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
}

struct AdditionalCostsRows: View {
    let tipShare: Decimal
    let taxShare: Decimal
    
    var body: some View {
        Group {
            HStack {
                Text("Tip")
                Spacer()
                Text(formattedCurrency(tipShare))
            }
            HStack {
                Text("Tax")
                Spacer()
                Text(formattedCurrency(taxShare))
            }
        }
        .font(.subheadline)
    }
}

struct PersonTotalView: View {
    let person: LegitP
    @ObservedObject var rviewModel: ReceiptViewModel
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: FatCheckTheme.Spacing.xs) {
            Text(formattedCurrency(total))
                .font(.title)
                .fontWeight(.bold)
            Text("Total")
                .font(.subheadline)
            if viewModel.currentUser?.id == rviewModel.receipt.userId{
                
                if person.userId != rviewModel.receipt.userId {
                    Button(action: { request() }) {
                        Text("Request")
                            .foregroundColor(FatCheckTheme.Colors.white)
                            .font(.subheadline)
                            .padding(8)
                            .frame(minWidth: 100)
                            .background(FatCheckTheme.Colors.primaryColor)
                            .cornerRadius(FatCheckTheme.Spacing.xs)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Toggle(isOn: Binding(
                        get: { person.paid },
                        set: { newValue in
                            rviewModel.updatePersonPaidStatus(personId: person.id, isPaid: newValue)
                        }
                    )) {
                        Text("Paid")
                            .font(.title2)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
                
            } else {
                if person.id == rviewModel.selectedPerson?.id{
                    Button(action: { request() }) {
                        Text("Pay Up")
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
    }
    
    struct CheckboxToggleStyle: ToggleStyle {
        func makeBody(configuration: Configuration) -> some View {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(configuration.isOn ? FatCheckTheme.Colors.primaryColor : .gray.opacity(0.4))
                    //Spacer()
                    configuration.label
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var total: Decimal {
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
        
        return personTotal + personTipShare + personTaxShare
    }
    
    private func request() {
        let payViewModel = PayBack()
        payViewModel.requestVenmo(amount: "\(total)")
    }
}

// Utility function for currency formatting
func formattedCurrency(_ amount: Decimal) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$0.00"
}

