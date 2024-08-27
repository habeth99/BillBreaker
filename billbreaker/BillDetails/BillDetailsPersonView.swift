import Foundation
import SwiftUI

//struct BillDetailsPersonView: View {
//    @ObservedObject var rviewModel: ReceiptViewModel
//    @ObservedObject var person: LegitP
//    var isSelected: Bool
//    
//    var body: some View {
//        let itemsWithPrice: [(Item, Decimal)] = person.claims.compactMap { claimID in
//            if let item = rviewModel.receipt.findItemById(id: claimID) {
//                // Calculate share of item price based on number of people claiming it
//                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
//                let sharePrice = item.price / Decimal(numberOfClaimants)
//                return (item, sharePrice)
//            }
//            return nil
//        }
//        
//        let total: Decimal = itemsWithPrice.reduce(into: 0) { $0 += $1.1 } // Sum up share prices
//        let tip: Decimal = rviewModel.receipt.calcTipShare(user: person, userTotal: total)
//        HStack{
//            VStack(alignment: .leading) {
//                HStack {
//                    Text("\(person.name)'s Check Summary")
//                        .padding([.top, .leading])
//                        .fontWeight(.semibold)
//                        .font(.title2)
//                    Spacer()
//                }
//                Spacer()
//                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
//                    HStack {
//                        Text(item.name)
//                            .font(.subheadline)
//                        Text("$\(sharePrice)")
//                            .font(.subheadline)
//                    }
//                    .padding([.leading, .trailing])
//                }
//                Text("Tip: $\(tip)")
//                    .padding(.leading)
//                    .padding(.top)
//                    .font(.subheadline)
//                Text("Total: $\(total)")
//                    .padding([.leading])
//                    .padding(.bottom)
//                    .font(.title3)
//            }
//                        if (isSelected) {
//                            VStack{
//                                Spacer()
//                                Button(action: {
//                                    print("Check Cashed")
//                                }) {
//                                    HStack{
//                                        Spacer()
//                                        Text("Checkout")
//                                            .foregroundColor(.black)  // Set text color to black
//                                            .padding()  // Add some padding inside the button
//                                            .background(Color.white)  // Set background color to white
//                                            .cornerRadius(8)  // Optional: Add rounded corners
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 8)
//                                                    .stroke(Color.black, lineWidth: 1)
//                                            ) 
//                                    }
//                                }
//                                .padding()
//                            }
//            }
//            
//        }
//        .frame(maxWidth: .infinity, minHeight: 150)
//        .background(isSelected ? person.color : person.color.opacity(0.2))
//        .cornerRadius(8)
//        .shadow(radius: 1)
//    
//    }
//}
struct BillDetailsPersonView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @ObservedObject var person: LegitP
    var isSelected: Bool
    
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
        let itemsWithPrice: [(Item, Decimal)] = person.claims.compactMap { claimID in
            if let item = rviewModel.receipt.findItemById(id: claimID) {
                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
                let sharePrice = item.price / Decimal(numberOfClaimants)
                return (item, sharePrice)
            }
            return nil
        }
        
        let total: Decimal = itemsWithPrice.reduce(into: 0) { $0 += $1.1 }
        let tip: Decimal = rviewModel.receipt.calcTipShare(user: person, userTotal: total)
        
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(person.name)'s Check Summary")
                        .padding([.top, .leading])
                        .fontWeight(.semibold)
                        .font(.title2)
                    Spacer()
                }
                Spacer()
                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
                    HStack {
                        Text(item.name)
                            .font(.subheadline)
                        Text(formattedCurrency(sharePrice))
                            .font(.subheadline)
                    }
                    .padding([.leading, .trailing])
                }
                Text("Tip: \(formattedCurrency(tip))")
                    .padding(.leading)
                    .padding(.top)
                    .font(.subheadline)
                Text("Total: \(formattedCurrency(total))")
                    .padding([.leading])
                    .padding(.bottom)
                    .font(.title3)
            }
            if (isSelected) {
                VStack {
                    Spacer()
                    Button(action: {
                        print("Check Cashed")
                    }) {
                        HStack {
                            Spacer()
                            Text("Checkout")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(isSelected ? person.color : person.color.opacity(0.2))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

