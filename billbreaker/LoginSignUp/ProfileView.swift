//
//  ProfileView.swift
//  billbreaker
//
//  Created by Nick Habeth on 5/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import Firebase

struct SettingsView: View {
    @EnvironmentObject var viewModel: UserViewModel
    @EnvironmentObject var router: Router
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showDeleteConfirmation = false
    @State private var isEditing = false
    
    // New state variables for editable fields
    @State private var editedName = ""
    @State private var editedEmail = ""
    @State private var editedVenmoHandle = ""
    @State private var editedCashAppHandle = ""

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
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        // Save changes when switching from Edit to Done
                        saveChanges()
                    } else {
                        // Initialize editable fields when switching to Edit mode
                        editedName = viewModel.currentUser?.name ?? ""
                        editedEmail = viewModel.currentUser?.email ?? ""
                        editedVenmoHandle = viewModel.currentUser?.venmoHandle ?? ""
                        editedCashAppHandle = viewModel.currentUser?.cashAppHandle ?? ""
                    }
                    isEditing.toggle()
                }
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
            Section {
                if isEditing {
                    TextField("Name", text: $editedName)
                    TextField("Email", text: $editedEmail)
                } else {
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
            }
            
            Section {
                if isEditing {
                    TextField("Venmo Handle", text: $editedVenmoHandle)
                } else {
                    SettingsRowView(imageName: "dollarsign.circle.fill", title: "Venmo: ", tintColor: .blue, descr: user.venmoHandle ?? "No Venmo")
                }
            }
            
            Section {
                if isEditing {
                    TextField("CashApp Handle", text: $editedCashAppHandle)
                } else {
                    SettingsRowView(imageName: "dollarsign.circle.fill", title: "CashApp: ", tintColor: .green, descr: user.cashAppHandle ?? "No CashApp")
                }
            }
            
            Section {
                Button(action: {
                    Task {
                        await viewModel.signOut()
                    }
                    router.resetToInitialState()
                    
                }) {
                    SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red, descr: "")
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button(action: {
                        showDeleteConfirmation = true
                    }) {
                        Text("Delete account")
                            .foregroundColor(.red)
                    }
                    .alert("Delete account", isPresented: $showDeleteConfirmation) {
                        Button("Yes", role: .destructive) {
                            Task {
                                await viewModel.deleteAccount()
                            }
                        }
                        Button("No", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to delete your account?")
                    }
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
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
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "ProfileView", code: 0, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
            }
            
            let db = Database.database().reference()
            let userRef = db.child("users").child(user.uid)
            
            let snapshot = try await userRef.getData()
            if let userData = snapshot.value as? [String: Any] {
                // Assuming you have a User model that conforms to Codable
                let jsonData = try JSONSerialization.data(withJSONObject: userData)
                let currentUser = try JSONDecoder().decode(User.self, from: jsonData)
                
                await MainActor.run {
                    viewModel.currentUser = currentUser
                    isLoading = false
                }
            } else {
                throw NSError(domain: "ProfileView", code: 1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func saveChanges() {
        // Update the user information in the ViewModel
        viewModel.updateUser(name: editedName, email: editedEmail, venmoHandle: editedVenmoHandle, cashAppHandle: editedCashAppHandle)
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
