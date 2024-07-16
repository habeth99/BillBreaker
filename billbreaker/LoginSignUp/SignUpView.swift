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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                TextField("Venmo Handle", text: $venmoHandle)
                TextField("Cash App Handle", text: $cashAppHandle)
                TextField("Password", text: $password)
                
                    
                Button("Sign Up") {
                    Task{
                        await viewModel.signUp(email: email, password: password, name: name, venmoHandle: venmoHandle, cashAppHandle: cashAppHandle)
                    }
                }
            }
            Button {
                dismiss()
            } label: {
                HStack{
                    Text("Already have an account?")
                    Text("Log in")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
            }
        }

    }
}

#Preview {
    SignUpView()
}
