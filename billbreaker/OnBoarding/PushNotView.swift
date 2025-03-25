//
//  CongratsView.swift
//  billbreaker
//
//  Created by Nick Habeth on 8/21/24.
//

import Foundation
import SwiftUI
import UserNotifications

//struct PushNotView: View {
//    @EnvironmentObject var router: Router
//    @EnvironmentObject var viewModel: UserViewModel
//    
//    var body: some View {
//        VStack {
//            Text("Do you want to receive push")
//                .font(.title)
//            Text("notifications for checks?")
//                .font(.title)
//            
//            Button(action: {
//                viewModel.onboardingAnswers.wantsPushNotifications = true
//            }) {
//                Text("Yes")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(viewModel.onboardingAnswers.wantsPushNotifications == true ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
//                    .padding()
//                    .background(viewModel.onboardingAnswers.wantsPushNotifications == true ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            
//            Button(action: {
//                viewModel.onboardingAnswers.wantsPushNotifications = false
//            }) {
//                Text("No")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(viewModel.onboardingAnswers.wantsPushNotifications == false ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
//                    .padding()
//                    .background(viewModel.onboardingAnswers.wantsPushNotifications == false ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            
//            Spacer()
//            
//            Button(action: {
//                viewModel.saveOnboardingAnswers()
//                router.resetAuth()
//            }) {
//                Text("Done")
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(FatCheckTheme.Colors.white)
//                    .padding()
//                    .background(FatCheckTheme.Colors.black)
//                    .cornerRadius(FatCheckTheme.Spacing.md)
//            }
//            .disabled(viewModel.onboardingAnswers.wantsPushNotifications == nil)
//        }
//        .padding(FatCheckTheme.Spacing.xl)
//        .background(FatCheckTheme.Colors.primaryColor)
//    }
//}

struct PushNotView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Do you want to receive push")
                .font(.title)
            Text("notifications for checks?")
                .font(.title)
            
            Button(action: {
                requestNotifications()
            }) {
                Text("Yes")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(viewModel.onboardingAnswers.wantsPushNotifications == true ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(viewModel.onboardingAnswers.wantsPushNotifications == true ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            
            Button(action: {
                viewModel.onboardingAnswers.wantsPushNotifications = false
            }) {
                Text("No")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(viewModel.onboardingAnswers.wantsPushNotifications == false ? FatCheckTheme.Colors.white : FatCheckTheme.Colors.primaryColor)
                    .padding()
                    .background(viewModel.onboardingAnswers.wantsPushNotifications == false ? FatCheckTheme.Colors.white.opacity(0.6) : FatCheckTheme.Colors.white)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.saveOnboardingAnswers()
                router.resetAuth()
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(FatCheckTheme.Colors.white)
                    .padding()
                    .background(FatCheckTheme.Colors.black)
                    .cornerRadius(FatCheckTheme.Spacing.md)
            }
            .disabled(viewModel.onboardingAnswers.wantsPushNotifications == nil)
        }
        .padding(FatCheckTheme.Spacing.xl)
        .background(FatCheckTheme.Colors.primaryColor)
    }
    
    private func requestNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                viewModel.onboardingAnswers.wantsPushNotifications = granted
            }
        }
    }
}
