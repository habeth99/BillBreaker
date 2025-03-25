import Foundation
import SwiftUI

//struct BillDetailsPersonView: View {
//    @ObservedObject var rviewModel: ReceiptViewModel
//    @ObservedObject var person: LegitP
//    var isSelected: Bool
//    
//    private let currencyFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.maximumFractionDigits = 2
//        formatter.minimumFractionDigits = 2
//        return formatter
//    }()
//    
//    private func formattedCurrency(_ amount: Decimal) -> String {
//        return currencyFormatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$0.00"
//    }
//    
//    var body: some View {
//        let itemsWithPrice: [(Item, Decimal)] = person.claims.compactMap { claimID in
//            if let item = rviewModel.receipt.findItemById(id: claimID) {
//                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
//                let sharePrice = item.price / Decimal(numberOfClaimants)
//                return (item, sharePrice)
//            }
//            return nil
//        }
//        
//        let total: Decimal = itemsWithPrice.reduce(into: Decimal.zero) { $0 += $1.1 }
//
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//                Text(person.name)
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
//                    HStack {
//                        Text(item.name)
//                            .font(.subheadline)
//                        Text(formattedCurrency(sharePrice))
//                            .font(.subheadline)
//                    }
//                }
//            }
//            
//            Spacer()
//            
//            VStack(alignment: .leading) {
//                Text("\(formattedCurrency(total))")
//                    .font(.largeTitle)
//                Text("Total")
//                    .font(.subheadline)
//                Button(action: payUp) {
//                    Text("Pay Up")
//                        .foregroundColor(.black)
//                        .font(.subheadline)
//                        .padding(4)
//                        .frame(minWidth: 100, minHeight: 48)
//                        .background(Color.white)
//                        .cornerRadius(FatCheckTheme.Spacing.xs)
//                }
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, minHeight: 10, alignment: .topLeading)
//        .background(isSelected ? person.color : person.color.opacity(0.2))
//        .cornerRadius(8)
//    }
//    
//    func payUp() {
//        //todo
//        print("guud good")
//    }
//}


