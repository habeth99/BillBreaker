//
//  ItemRowView.swift
//  billbreaker
//
//  Created by Nick Habeth on 7/3/24.
//

import Foundation
import SwiftUI

struct ItemRowView: View {
    var item: Item
    var users: [LegitP]
    @ObservedObject var rviewModel: ReceiptViewModel
    
    var body: some View {
        VStack{
            HStack {
                Text(item.name)
                    .padding()
                ForEach(users ?? [], id: \.id) { person in

                    if (!users.isEmpty) {
                        Circle()
                            .fill(person.color)
                            .frame(width: 19, height: 19)
                            .padding(.vertical)
                            .overlay(
                                Text(person.name.prefix(1)) // Display only the first letter to fit the circle
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                    }
                }
                Spacer()
                Text(String(format: "$%.2f", item.price))
                    .padding()
            }
            .onTapGesture {
                if rviewModel.selectedPerson != nil {
                    rviewModel.toggleItemSelection(item)
                } else {
                    print("No person selected")
                }
            }
        }
    }
}

