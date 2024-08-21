//
//  SplittingFor.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct SplittingFor: View {
    var body: some View {

        VStack {
            Text("What do you split costs")
                .font(.title)
            Text("for?")
                .font(.title)
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Meals")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Drinks")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Appetizers")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Desserts")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Tips")
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
    SplittingFor()
}
