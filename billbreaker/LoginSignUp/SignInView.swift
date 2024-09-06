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
                    print("before handle with completion call")
                    viewModel.handleSignInWithCompletion(result)
                    print("after handle with completion call")
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 56)
            .cornerRadius(FatCheckTheme.Spacing.sm)
            .padding(.horizontal)
        
            Spacer()
        }
    }
}

// Preview
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//            .environmentObject(UserViewModel())
//    }
//}

// CUSTOM apple buttons should i need them
//            Button(action: {
//                //viewModel.signInWithApple()
//            }) {
//                HStack {
//                    Image(systemName: "apple.logo")
//                    Text("Sign in with Apple")
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.black)
//                .cornerRadius(FatCheckTheme.Spacing.sm)  // Adjust the radius as needed
//                .foregroundColor(.white)
//            }
//            .padding(.horizontal)

//            Button(action: {
//                // Perform sign in with Apple, then navigate to onboarding
//            }) {
//                HStack {
//                    Image(systemName: "apple.logo")
//                    Text("Sign up with Apple")
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.black)
//                .cornerRadius(FatCheckTheme.Spacing.sm)  // Adjust the radius as needed
//                .foregroundColor(.white)
//            }
//            .padding(.horizontal)
