import Foundation
import SwiftUI

struct BillDetailsPersonView: View {
    @ObservedObject var rviewModel: ReceiptViewModel
    @ObservedObject var person: LegitP
    var isSelected: Bool
    
    
    var body: some View {
        let items: [Item] = person.claims.map {rviewModel.receipt.findItemById(id: $0) ?? Item()}
        let total: Double = items.reduce(into: 0) { $0 += $1.price }
        
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
            ForEach(items, id: \.id) { item in
                HStack {
                    Text(item.name)
                    Text(String(format: "$%.2f", item.price))
                }
                .padding([.leading, .trailing])
            }
            Text("Total: \(String(format: "%.2f", total))")
                .padding([.leading])
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(isSelected ? person.color : person.color.opacity(0.2))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}
