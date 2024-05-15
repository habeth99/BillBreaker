//
//  ProfileView.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/9/24.
//

//import Foundation
//import SwiftUI
//import FirebaseAuth
//
//struct ProfileView: View {
//    @EnvironmentObject var viewModel: UserViewModel
//    let test2 = Auth.auth().currentUser?.uid
//    
//    var body: some View {
//        if let user = viewModel.currentUser {
//            List {
//                Section {
//                    HStack {
////                        Text(user.initials)
////                            .font(.title)
////                            .fontWeight(.semibold)
////                            .foregroundColor(.white)
////                            .frame(width: 72, height: 72)
////                            .background(Color(.systemGray3))
////                            .clipShape(Circle())
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text(user.name)
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .padding(.top, 4)
//                            Text(user.email)
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                    }
//                }
//                
//                Section("Account") {
//                    
//                    Button(action: {
//                        viewModel.signOut()
//                    }) {
//                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
//                    }
//                    
//                    Button(action: {
//                        Task{
//                            try await
//                            viewModel.deleteAccount()
//                        }
//                        
//                    }) {
//                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
//                    }
//                    
//                }
//            }
//        } else {
//            Text("No user info available")
//        }
//    }
//}
import Foundation
import SwiftUI
import FirebaseAuth

struct ProfileView: View {
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
                                viewModel.signOut()
                            }) {
                                SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                            }
                            
//                            Button(action: {
//                                Task {
//                                    do {
//                                        try await viewModel.deleteAccount()
//                                    } catch {
//                                        // Handle error (e.g., show an alert)
//                                        print("Error deleting account: \(error)")
//                                    }
//                                }
//                            }) {
//                                SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
//                            }
                        }
                    }
                }
            } else {
                Text("No user info available")
                
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
