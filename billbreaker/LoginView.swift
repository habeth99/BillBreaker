//
//  LoginView.swift
//  billbreaker
//
//  Created by Nick Habeth on 4/8/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var password: String = ""
    @State private var email: String = ""
    @EnvironmentObject var viewModel: UserViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Email", text: $email)
                    TextField("Password", text: $password)
                    Button("Log In") {
                        Task {
                            await viewModel.signIn(email: email, password: password)
                        }
                    }
                }
                NavigationLink {
                    SignUpView()
                } label: {
                    HStack{
                        Text("Don't have an account?")
                        Text("Sign in")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

// Preview
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//            .environmentObject(UserViewModel())
//    }
//}
