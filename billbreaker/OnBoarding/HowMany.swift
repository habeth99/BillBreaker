//
//  HowMany.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct HowMany: View {
    var body: some View {

        VStack {
            Text("How many people are")
                .font(.title)
            Text("usually in your dining")
                .font(.title)
            Text("group?")
                .font(.title)
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("2-3")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("4-6")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("7-10")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("10+")
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
    HowMany()
}
