//
//  SignUpView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/7/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

struct SignUpView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var venmoHandle: String = ""
    @State private var cashAppHandle: String = ""
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    
    @State private var showTerms = false
    @State private var showPrivacyPolicy = false
    
    var body: some View {
        VStack {
            Text("Create an account")
                .font(.system(size: 32))
                .padding(.top, FatCheckTheme.Spacing.xxxl)
            
            Spacer()
            
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    viewModel.handleSignInWithAppleRequest(request)
                },
                onCompletion: { result in
                    print("before handle with completion call")
                    viewModel.handleSignInWithCompletion(result)
                    print("after handle with completion call")
                    viewModel.isNewUser = true
                    router.navigateAuth(to: .mostExcited)
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(maxHeight: 56)
            .cornerRadius(FatCheckTheme.Spacing.sm)
            .padding(.horizontal)
            
            VStack (alignment: .leading) {
                HStack {
                    Text("By signing up, you agree to the")
                        .font(.caption)
                    
                    
                    Button("Terms of Service") {
                        showTerms = true
                    }
                    .sheet(isPresented: $showTerms) {
                        LegalDocumentView(title: "Terms of Service", urlString: "https://www.fatcheck.app/tos")
                    }
                    .font(.caption)
                    
                    Text("and")
                        .font(.caption)
                }
                .padding(.top, FatCheckTheme.Spacing.md)
                
                Button("Privacy Policy") {
                    showPrivacyPolicy = true
                }
                .sheet(isPresented: $showPrivacyPolicy) {
                    LegalDocumentView(title: "Privacy Policy", urlString: "https://www.fatcheck.app/privacy")
                }
                .font(.caption)
            }
            
            Spacer()
            
        }
    }
}

//#Preview {
//    SignUpView()
//}
