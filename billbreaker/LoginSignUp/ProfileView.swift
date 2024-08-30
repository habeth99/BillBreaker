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
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading user data...")
            } else if let user = viewModel.currentUser {
                userSettingsList(user: user)
            } else {
                noUserView
            }
        }
        .onAppear(perform: fetchUserIfNeeded)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }

    private var noUserView: some View {
        VStack {
            Text("No user info available")
            Button("Refresh User Data") {
                fetchUserIfNeeded()
            }
            Button("Dev SignOut") {
                Task {
                    await viewModel.signOut()
                }
            }
        }
    }

    private func userSettingsList(user: User) -> some View {
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
                SettingsRowView(imageName: "dollarsign.circle.fill", title: "Venmo: ", tintColor: .blue, descr: user.venmoHandle)
            }
            
            Section {
                SettingsRowView(imageName: "dollarsign.circle.fill", title: "CashApp: ", tintColor: .green, descr: user.cashAppHandle)
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.signOut()
                    }
                }) {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red, descr: "")
                }
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.deleteAccount()
                    }
                }) {
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
        }
        .refreshable {
            await refreshUser()
        }
    }

    private func fetchUserIfNeeded() {
        if viewModel.currentUser == nil {
            Task {
                await refreshUser()
            }
        }
    }

    private func refreshUser() async {
        isLoading = true
        do {
            viewModel.fetchUser()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showError = true
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
                .foregroundColor(tintColor)
            Text(title)
            Spacer()
            Text(descr)
        }
    }
}
