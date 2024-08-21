//
//  BigFrustration.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct BigFrustration: View {
    var body: some View {

        VStack {
            Text("What's your biggest")
                .font(.title)
            Text("frustration when")
                .font(.title)
            Text("splitting checks?")
                .font(.title)
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Calculating individual amounts")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Remembering who ordered what")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Dealing with tax and tip")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Chasing payments from friends")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Other")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Spacer()
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.white)
                    .padding()
                    .background(FatCheckTheme.Colors.black)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
        }
        .padding(FatCheckTheme.Spacing.xl)
        .background(FatCheckTheme.Colors.primaryColor)
    }
}

#Preview {
    BigFrustration()
}
