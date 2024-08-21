//
//  DefaultTip.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct DefaultTip: View {
    var body: some View {

        VStack {
            Text("Would you like to set a")
                .font(.title)
            Text("default tip percentage?")
                .font(.title)
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Yes")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("No")
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
    DefaultTip()
}
