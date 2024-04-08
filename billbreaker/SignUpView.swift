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
    @State private var venmoHandle: String = ""
    @State private var cashAppHandle: String = ""
    @StateObject var viewModel = UserViewModel()
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("Venmo Handle", text: $venmoHandle)
            TextField("Cash App Handle", text: $cashAppHandle)
                
            Button("Sign Up") {
                let newUser = User(name: name, venmoHandle: venmoHandle, cashAppHandle: cashAppHandle)
                viewModel.writeUserToFirebase(newUser)
            }
        }
    }
}

#Preview {
    SignUpView()
}
