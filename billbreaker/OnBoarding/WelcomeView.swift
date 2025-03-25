//
//  WelcomeView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to FatCheck!")
                .font(.largeTitle)
                .bold()
                .padding(FatCheckTheme.Spacing.xxxl)
            Text("Ready to simplfy")
                .font(.title2)
            Text("your dining experience?")
                .font(.title2)
            Spacer()
            Button(action: {
                print("getting started!!!!!")
            }) {
                Text("Get Started")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            .padding(FatCheckTheme.Spacing.xl)
            
        }
        .background(FatCheckTheme.Colors.primaryColor)
    }
}

#Preview {
    WelcomeView()
}
