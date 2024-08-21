//
//  SplitMethod.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct SplitMethod: View {
    var body: some View {

        VStack {
            Text("What's your preferred")
                .font(.title)
            Text("method of splitting")
                .font(.title)
            Text("checks?")
                .font(.title)
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Equal split")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Split by what each person ordered")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("One person pays, others pay them back")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("It varies")
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
    SplitMethod()
}
