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
//        HStack {
//            VStack (alignment: .leading, spacing: 0){
//                HStack(alignment: .top) {
//                    Text("\(person.name)")
//                        .fontWeight(.semibold)
//                        .font(.subheadline)
//                    Text("Total: \(formattedCurrency(total))")
//                        .font(.subheadline)
//                    Button(action: payUp) {
//                        Text("Pay Up")
//                            .foregroundStyle(Color.black)
//                            .font(.subheadline)
//                    }
//                }
//                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
//                    HStack {
//                        Text(item.name)
//                            .font(.subheadline)
//                        Text(formattedCurrency(sharePrice))
//                            .font(.subheadline)
//                    }
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, minHeight: 150)
//        .background(isSelected ? person.color : person.color.opacity(0.2))
//        .cornerRadius(8)
//    }
//    
//    func payUp() {
//        //todo
//        print("guud good")
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
        
        let total: Decimal = itemsWithPrice.reduce(into: Decimal.zero) { $0 += $1.1 }

//        VStack(alignment: .leading, spacing: 0) {
//            HStack {
//                Text(person.name)
//                    .fontWeight(.semibold)
//                    .font(.subheadline)
//                Spacer()
//            }
//            
//            ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
//                HStack {
//                    Text(item.name)
//                        .font(.subheadline)
//                    Spacer()
//                    Text(formattedCurrency(sharePrice))
//                        .font(.subheadline)
//                }
//            }
//            
//            HStack {
//                Text("Total: \(formattedCurrency(total))")
//                    .font(.subheadline)
//                Spacer()
//                Button(action: payUp) {
//                    Text("Pay Up")
//                        .foregroundColor(.black)
//                        .font(.subheadline)
//                        .padding(4)
//                        .background(Color.yellow)
//                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs)
//                                .stroke(Color.black, lineWidth: 2)
//                        )
//                }
//            }
//             
//        }
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                ForEach(itemsWithPrice, id: \.0.id) { item, sharePrice in
                    HStack {
                        Text(item.name)
                            .font(.subheadline)
                        Text(formattedCurrency(sharePrice))
                            .font(.subheadline)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("\(formattedCurrency(total))")
                    .font(.largeTitle)
                Text("Total")
                    .font(.subheadline)
                Button(action: payUp) {
                    Text("Pay Up")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .padding(4)
                        .frame(minWidth: 100, minHeight: 48)
                        .background(Color.white)
                        .cornerRadius(FatCheckTheme.Spacing.xs)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 10, alignment: .topLeading)
        .background(isSelected ? person.color : person.color.opacity(0.2))
        .cornerRadius(8)
    }
    
    func payUp() {
        //todo
        print("guud good")
    }
}


//struct BillDetailsPersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create mock data
//        let mockReceiptViewModel = ReceiptViewModel()
//    
//        let receipt = Receipt(
//            id: "receipt1",
//            date: "", tax: 1.50, tip: 3.50, items: [
//                Item(id: "item1", name: "Burger", price: 10.99),
//                Item(id: "item2", name: "Fries", price: 3.99),
//                Item(id: "item3", name: "Soda", price: 2.49)
//            ],
//            people: [], total: 22.47
//        )
//        
//        let mockPerson = LegitP(
//            id: "person1",
//            name: "John Doe",
//            userId: "user1",
//            claims: ["item1", "item2"],
//            paid: false,
//            color: .blue
//        )
//        
//        // Create the view
//        BillDetailsPersonView(
//            rviewModel: mockReceiptViewModel,
//            person: mockPerson,
//            isSelected: true
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}

