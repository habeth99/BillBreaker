//
//  LoginView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @State private var password: String = ""
    @State private var email: String = ""
    @EnvironmentObject var viewModel: UserViewModel
    @State private var currentNonce: String?
    
    var body: some View {
        VStack{
            Text("Welcome back!")
                .font(.system(size: 32))
                .padding(.top, FatCheckTheme.Spacing.xxxl)
            Text("We've missed you")
                .font(.subheadline)
            Spacer()
            //Sign In with Apple Button
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    viewModel.handleSignInWithAppleRequest(request)
                },
                onCompletion: { result in
                    viewModel.handleSignInWithCompletion(result)
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 56)
            .cornerRadius(FatCheckTheme.Spacing.sm)
            .padding(.horizontal, FatCheckTheme.Spacing.xl)
        
            Spacer()
        }
    }
}
