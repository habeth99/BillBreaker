//
//  HasNotPaid.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct HaveNotPaid: View {
    let friends: [LegitP]
    private let circleSize: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(friends.filter { !$0.paid }, id: \.id) { friend in
                Circle()
                    .fill(FatCheckTheme.Colors.white)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .strokeBorder(FatCheckTheme.Colors.primaryColor, lineWidth: 2)
                    )
                    .overlay(
                        Text(friend.getFirstInitial())
                            .foregroundColor(FatCheckTheme.Colors.primaryColor)
                            .font(.system(size: 14, weight: .bold))
                    )
            }
        }
    }
}

