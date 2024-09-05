//
//  SignUpView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/7/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var venmoHandle: String = ""
    @State private var cashAppHandle: String = ""
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("Create an account")
                .font(.system(size: 32))
                .padding(.top, FatCheckTheme.Spacing.xxxl)
            
            Spacer()
            
            Button(action: {
                // Perform sign in with Apple, then navigate to onboarding
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                    Text("Sign up with Apple")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(FatCheckTheme.Spacing.sm)  // Adjust the radius as needed
                .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            Text("By signing up, you agree to the Terms of Service and Privacy Policy")
                .font(.caption)
                .padding(FatCheckTheme.Spacing.sm)
            
            Spacer()
        }
    }
}

#Preview {
    SignUpView()
}
