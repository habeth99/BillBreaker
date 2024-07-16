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
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Welcome to fatcheck!")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Button(action: {
                viewModel.showLoginView = true
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 30)
                    .font(.title)
                    .padding()
                    .background(Color.green.opacity(0.5))
                    .foregroundColor(.black)
                    .cornerRadius(6)
            }
            .padding(.horizontal)
            .sheet(isPresented: $viewModel.showLoginView) {
                LoginView()
                    .environmentObject(viewModel)
            }
            
            Button(action: {
                viewModel.showSignupView = true
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: 30)
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(6)
            }
            .padding(.horizontal)
            .sheet(isPresented: $viewModel.showSignupView) {
                SignUpView()
                    .environmentObject(viewModel)
            }
            
            // Sign In with Apple Button
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    viewModel.handleSignInWithAppleRequest(request)
                },
                onCompletion: { result in
                    print("before handle with completion call")
                    viewModel.handleSignInWithCompletion(result)
                    print("after handle with completion call")
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 60)
            .padding(.horizontal)
        }
    }
}


