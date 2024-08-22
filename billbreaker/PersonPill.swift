//
//  PersonPill.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct PersonPill: View {
    var person: LegitP
    var amountOwed: Double
    
    var body: some View {
        Button(action: openLink) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(person.color)
                    .frame(width: 45, height: 32)
                    .overlay(
                        Text(person.getFirstInitial())
                            .foregroundColor(.black)
                    )
                Rectangle()
                    .fill(Color.red.opacity(0.3))
                    .frame(width: 60, height: 32)
                    .overlay(
                        Text("-$\(String(format: "%.2f", amountOwed))")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    )
            }
            .frame(width: 105, height: 32) // Ensure consistent overall size
            .clipShape(RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs, style: .continuous))
        }
    }
    
    func openLink() {
        // TODO: Implement openLink functionality
        print("i would be surprised")
    }
}

//#Preview {
//    PersonPill()
//}
