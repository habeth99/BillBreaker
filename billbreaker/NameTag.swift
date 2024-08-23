//
//  PersonPill.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct NameTag: View {
    var person: LegitP
    var amountOwed: Double
    
    var body: some View {
        Button(action: openLink) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(person.color.opacity(0.7))
                    .frame(width: 338, height: 32)
                    .overlay(
                        HStack (spacing: 0){
                            Text(person.name)
                                .foregroundColor(.black)
                                .padding(.horizontal, FatCheckTheme.Spacing.md)
                            Spacer()
                            Text("-$\(String(format: "%.2f", amountOwed))")
                                .foregroundColor(.black)
//                                .padding(.horizontal, FatCheckTheme.Spacing.md)
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .padding( FatCheckTheme.Spacing.md)
                        }
                    )
            }
            .frame(width: 338, height: 32) // Ensure consistent overall size
            .clipShape(RoundedRectangle(cornerRadius: FatCheckTheme.Spacing.xs, style: .continuous))
        }
    }
    
    func openLink() {
        // TODO: Implement openLink functionality
        print("i would be surprised")
    }
}

let mockperson = LegitP(name: "Jake", color: .green)

struct NameTag_Previews: PreviewProvider {
    static var previews: some View {
        NameTag(person: mockperson, amountOwed: 20.00)
    }
}

