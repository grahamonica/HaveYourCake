//
//  MainLoginView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI
import SwiftData

struct MainLoginView: View {
    @State private var showLoginPopup: Bool = false
    @State private var showCreateAccount: Bool = false
    @Binding var navigateToHome: Bool // Supplied as a binding from the parent view
    @State private var errorMessage: String? = nil
    @Environment(\.modelContext) private var context: ModelContext // Access SwiftData context

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Welcome to HaveYourCake")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Constants.Colors.primaryColor)

                Spacer()

                // Login Buttons
                VStack(spacing: Constants.Layout.spacing) {
                    // Login with Username
                    Button(action: {
                        showLoginPopup = true
                    }) {
                        Text("Login with Username")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Layout.cornerRadius)
                    }

                    // Login with Google
                    Button(action: {
                        loginAsUser(type: "Google")
                    }) {
                        Text("Login with Google")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.secondaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Layout.cornerRadius)
                    }

                    // Login with Apple
                    Button(action: {
                        loginAsUser(type: "Apple")
                    }) {
                        Text("Login with Apple")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.Layout.cornerRadius)
                    }

                    // Continue as Guest
                    Button(action: {
                        loginAsGuest()
                    }) {
                        Text("Continue as Guest")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.backgroundColor)
                            .foregroundColor(Constants.Colors.primaryColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius)
                                    .stroke(Constants.Colors.primaryColor, lineWidth: 2)
                            )
                    }
                }
                .padding(.horizontal, Constants.Layout.padding)

                Spacer()

                // Create Account Button
                Button(action: {
                    showCreateAccount = true
                }) {
                    Text("Create Account")
                        .underline()
                        .foregroundColor(Constants.Colors.primaryColor)
                }

                Spacer()

                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Constants.Colors.errorColor)
                        .font(.caption)
                }
            }
            .padding()
            .background(Constants.Colors.backgroundColor)
            .fullScreenCover(isPresented: $showLoginPopup) {
                LoginWithUsernamePopup()
            }
            .fullScreenCover(isPresented: $showCreateAccount) {
                CreateAccountView()
            }
            .background(
                NavigationLink(
                    destination: HomeView(),
                    isActive: $navigateToHome
                ) { EmptyView() }
            )
            .onAppear {
                checkIfUserIsLoggedIn()
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Actions

    private func loginAsUser(type: String) {
        // Simulate successful login
        let user = UserModel(isGuest: false)
        context.insert(user)
        try? context.save()
        navigateToHome = true
        print("Logged in as \(type). Navigate to HomeView.")
    }

    private func loginAsGuest() {
        // Check if a guest user already exists
        let guestUser = PersistentContainer.shared.fetchGuestUser() ?? {
            let newGuest = UserModel(isGuest: true)
            context.insert(newGuest)
            try? context.save()
            return newGuest
        }()
        navigateToHome = true
        print("Logged in as Guest. Navigate to HomeView.")
    }

    private func checkIfUserIsLoggedIn() {
        if let guestUser = PersistentContainer.shared.fetchGuestUser() {
            print("Guest user found: \(guestUser.fullName)")
            navigateToHome = true
        } else if !PersistentContainer.shared.fetchAllUsers().isEmpty {
            print("Authenticated user found. Navigate to HomeView.")
            navigateToHome = true
        } else {
            print("No user logged in.")
            navigateToHome = false
        }
    }
}
