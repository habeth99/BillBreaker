import Foundation
import SwiftUI

struct BillDetailsPersonView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @ObservedObject var person: LegitP
    var isSelected: Bool
    
    var body: some View {
        let itemsWithPrice: [(Item, Double)] = person.claims.compactMap { claimID in
            if let item = rviewModel.receipt.findItemById(id: claimID) {
                // Calculate share of item price based on number of people claiming it
                let numberOfClaimants = rviewModel.receipt.countPeopleClaiming(itemID: claimID)
                let sharePrice = item.price / Double(numberOfClaimants)
                return (item, sharePrice)
            }
            return nil
        }
        
        let total: Double = itemsWithPrice.reduce(into: 0) { $0 += $1.1 } // Sum up share prices
        let tip: Double = rviewModel.receipt.calcTipShare(user: person, userTotal: total)
        HStack{
            VStack(alignment: .leading) {
                HStack {
                    Text(person.name)
                        .padding([.top, .leading])
                        .fontWeight(.bold)
                    Spacer()
                }
                Spacer()
                Text("Claims:")
                    .padding([.leading])
                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
                    HStack {
                        Text(item.name)
                        Text(String(format: "$%.2f", sharePrice))
                    }
                    .padding([.leading, .trailing])
                }
                Text("Tip: \(String(format: "%.2f", tip))")
                    .padding(.leading)
                Text("Total: \(String(format: "%.2f", total))")
                    .padding([.leading])
                    .padding(.bottom)
            }
                        if (isSelected) {
                            VStack{
                                Spacer()
                                Button(action: {
                                    print("Check Cashed")
                                }) {
                                    HStack{
                                        Spacer()
                                        Text("Checkout")
                                            .foregroundColor(.black)  // Set text color to black
                                            .padding()  // Add some padding inside the button
                                            .background(Color.white)  // Set background color to white
                                            .cornerRadius(8)  // Optional: Add rounded corners
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.black, lineWidth: 1)
                                            )  // Optional: Add a black border
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

