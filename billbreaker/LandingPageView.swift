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
            Text("Welcome to the App")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                viewModel.showLoginView = true
            }) {
                Text("Login")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .sheet(isPresented: $viewModel.showLoginView) {
                LoginView()
                    .environmentObject(viewModel)
            }
            
            Button(action: {
                viewModel.showSignupView = true
            }) {
                Text("Sign Up")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
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
            .frame(width: 280, height: 60)
            .padding()
        }
    }
}


