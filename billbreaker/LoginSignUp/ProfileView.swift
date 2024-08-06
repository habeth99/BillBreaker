//
//  ProfileView.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject var viewModel: UserViewModel
    //let test2 = Auth.auth().currentUser?.uid
    
    var body: some View {
        Group {  // Wrap your conditional in a Group or another view
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Section("Account") {
                        VStack{
                            Button(action: {
                                Task{
                                    await viewModel.signOut()
                                }
                            }) {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                            }
                        }
                    }
                }
            } else {
                VStack{
                    Text("No user info available")
                    Button(action: {
                        Task {
                            await viewModel.signOut()
                        }
                    }, label: {
                        Text("Dev SignOut")
                    })
                }
            }
        }
    }
}


struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}
