//
//  DefaultTip.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI

//struct DefaultTipView: View {
//    @EnvironmentObject var router: Router
//    @EnvironmentObject var viewModel: UserViewModel
//    
//    var body: some View {
//        VStack {
//            Text("Would you like to set a")
//                .font(.title)
//            Text("default tip percentage?")
//                .font(.title)
//            
//            Button(action: {
//                viewModel.onboardingAnswers.defaultTipPercentage = true
//            }) {
//                Text("Yes")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(viewModel.onboardingAnswers.defaultTipPercentage == true ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
//                    .padding()
//                    .background(viewModel.onboardingAnswers.defaultTipPercentage == true ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            
//            Button(action: {
//                viewModel.onboardingAnswers.defaultTipPercentage = false
//            }) {
//                Text("No")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(viewModel.onboardingAnswers.defaultTipPercentage == false ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
//                    .padding()
//                    .background(viewModel.onboardingAnswers.defaultTipPercentage == false ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                router.navigateAuth(to: .pushNot)
//            }) {
//                Text("Next")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(FatCheckTheme.Colors.white)
//                    .padding()
//                    .background(FatCheckTheme.Colors.black)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            .disabled(viewModel.onboardingAnswers.defaultTipPercentage == nil)
//        }
//        .padding(FatCheckTheme.Spacing.xl)
//        .background(FatCheckTheme.Colors.primaryColor)
//    }
//}
