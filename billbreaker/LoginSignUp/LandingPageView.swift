//
//  LandingPageView.swift
//  billbreaker
//
//  Created by Nick Habeth on 6/15/24.
//

import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct LandingPageView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.authPath) {
            VStack {
                Text("FatCheck")
                    .font(.system(size: 50))
                    .padding(.top, FatCheckTheme.Spacing.xxxl)

                Text("tab splitter")
                    .font(.subheadline)
                    .padding(.bottom, FatCheckTheme.Spacing.xxxl)
                
                Spacer()
                
                Button(action: {
                    router.navigateAuth(to: .signIn)
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(FatCheckTheme.Spacing.sm)
                .padding(.horizontal, FatCheckTheme.Spacing.xl)

                Button(action: {
                    router.navigateAuth(to: .signUp)
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(FatCheckTheme.Colors.primaryColor)
                .cornerRadius(FatCheckTheme.Spacing.sm)
                .padding(.horizontal, FatCheckTheme.Spacing.xl)
                
                .padding(.bottom, FatCheckTheme.Spacing.xxxl)
            }
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signIn:
                    SignInView()
                case .signUp:
                    SignUpView()
                case .mostExcited:
                    MostExcitedView()
                case .pushNot:
                    PushNotView()

                }
            }
        }
    }
}


