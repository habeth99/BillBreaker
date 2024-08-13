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

    
    var body: some View {
        Group {
            
            if let user = viewModel.currentUser {
                List {
                    Section("Profile") {
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
                    Section {
                        VStack{
                            SettingsRowView(imageName: "dollarsign.circle.fill", title: "Venmo: ", tintColor: .blue, descr: viewModel.currentUser?.venmoHandle ?? "")
                        }
                    }
                    
                    Section {
                        VStack{
                            SettingsRowView(imageName: "dollarsign.circle.fill", title: "CashApp: ", tintColor: .green, descr: viewModel.currentUser?.cashAppHandle ?? "")
                        }
                    }
                    
                    Section{
                        VStack{
                            Button(action: {
                                Task{
                                    await viewModel.signOut()
                                }
                            }) {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red, descr: "")
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
    let descr: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            Text(descr)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}
