//
//  BigFrustration.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

struct MostExcitedView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("What FatCheck features")
                .font(.title)
            Text("are you most")
                .font(.title)
            Text("excited for?")
                .font(.title)
            
            ForEach(["Receipt photo scan",
                     "Easy to send reminders for friends",
                     "Paid back tracking",
                     "Friend pay back metrics",
                     "Receipt Tracking"], id: \.self) { feature in
                Button(action: {
                    viewModel.onboardingAnswers.mostExcitedFeature = feature
                }) {
                    Text(feature)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewModel.onboardingAnswers.mostExcitedFeature == feature ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
                        .padding()
                        .background(viewModel.onboardingAnswers.mostExcitedFeature == feature ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
                        .cornerRadius(FatCheckTheme.Spacing.md)
                }
            }
            
            Spacer()
            
            Button(action: {
                router.navigateAuth(to: .defaultTip)
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.white)
                    .padding()
                    .background(FatCheckTheme.Colors.black)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            .disabled(viewModel.onboardingAnswers.mostExcitedFeature == nil)
        }
        .padding(FatCheckTheme.Spacing.xl)
        .background(FatCheckTheme.Colors.primaryColor)
    }
}
