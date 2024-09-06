//
//  CheckCardView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/14/24.
//

import Foundation
import SwiftUI

struct CheckCard: View {
    var receipt: Receipt
    @EnvironmentObject var router: Router
    @EnvironmentObject var userViewModel: UserViewModel // Assuming you have a UserViewModel to get the current user
    
    private var progressValue: Double {
        let amountPaid = receipt.getTotal() - receipt.amtOwed()
        return (amountPaid as NSDecimalNumber).doubleValue / (receipt.getTotal() as NSDecimalNumber).doubleValue
    }
    
    private var unpaidPeople: [LegitP] {
        receipt.people?.filter { person in
            !person.paid && person.userId != userViewModel.currentUser?.id
        } ?? []
    }
    
    init(receipt: Receipt){
        self.receipt = receipt
    }
    
    var body: some View {
        Button(action: navTo) {
            VStack (alignment: .leading, spacing: 0) {
                HStack(alignment:.top) {
                    Text(receipt.name)
                        .font(.title)
                    Spacer()
                    Text(receipt.formatDate(), style: .date)
                        .font(.subheadline)
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                HStack{
                    CardDetails(total: receipt.amtOwed(), title: "Amount owed")
                    Spacer()
                    CardDetails(total: receipt.getTotal(), title: "Total")
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                
                VStack {
                    ProgressView(value: progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: FatCheckTheme.Colors.primaryColor))
                }
                .padding(.bottom, FatCheckTheme.Spacing.sm)
                
                VStack (alignment: .leading) {
                    if !unpaidPeople.isEmpty {
                        Text("Not paid up")
                            .font(.subheadline)
                        ForEach(unpaidPeople) { person in
                            NameTag(person: person, amountOwed: receipt.amountOwedByPerson(person.id), receipt: receipt)
                        }
                    } else {
                        Text("Everyone has paid!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(FatCheckTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.sm)
                    .fill(FatCheckTheme.Colors.white)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func navTo() {
        router.navigateToReceipt(id: receipt.id)
    }
}
