//
//  GuestSignInView.swift
//  billbreaker
//
//  Created by Nick Habeth on 6/14/24.
//

import Foundation
import SwiftUI

struct GuestSignInView: View {
    @State private var guestName = ""
    
    var body: some View {
        VStack{
            Text("Guest SignIn View")
            TextField("Enter Name", text: $guestName)
                .padding()
                .frame(width: 200, height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()
            Button(action: {
                print("Signing in Guest!")
            }, label: {
                Text("Sign in as Guest")
            })
        }
    }
}

#Preview {
    GuestSignInView()
}
