//
//  ItemView.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/30/24.
//

//import Foundation
//import SwiftUI
//
//struct ItemView: View{
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            // MARK: Header
//            Text("Items")
//                .font(.title)
//                .fontWeight(.bold)
//            VStack(alignment: .leading) {
//                ForEach(receipt.items ?? [], id: \.id) { item in
//                    HStack {
//                        Text(item.name)
//                            .padding()
//                        Spacer()
//                        Text(String(format: "$%.2f", item.price))
//                            .padding()
//                    }
//                    .background(selectedItems.contains(item.id) ? Color.blue.opacity(0.3) : Color.clear)
//                    .onTapGesture {
//                        if let selectedPerson = selectedPerson {
//                            toggleItemSelection(item.id)
//                        } else {
//                            print("No person selected")
//                        }
//                    }
//                }
//            }
//            .background(Color.white)
//            .cornerRadius(12)
//            .frame(width: 361)
//            .shadow(radius: 1)
//        }
//    }
//}
