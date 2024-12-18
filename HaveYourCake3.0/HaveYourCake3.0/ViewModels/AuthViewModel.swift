//
//  AuthViewModel.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import Foundation
import SwiftData

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserModel? = nil
    @Published var errorMessage: String? = nil

    private let container = PersistentContainer.shared

    // MARK: - Login with Username
    func loginWithUsername(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }

        // Placeholder authentication logic
        if username == "testuser" && password == "password123" {
            // Simulated login success
            let user = fetchOrCreateAuthenticatedUser(
                firstName: "Test",
                lastName: "User",
                email: "testuser@example.com"
            )
            currentUser = user
            isAuthenticated = true
            errorMessage = nil
        } else {
            // Simulated login failure
            errorMessage = "Invalid username or password."
        }
    }

    // MARK: - Login as Guest
    func loginAsGuest() {
        if let guestUser = container.fetchGuestUser() {
            currentUser = guestUser
        } else {
            let newGuest = UserModel(isGuest: true)
            container.context.insert(newGuest)
            container.saveContext()
            currentUser = newGuest
        }

        isAuthenticated = true
        errorMessage = nil
    }

    // MARK: - Logout
    func logout() {
        currentUser = nil
        isAuthenticated = false
        errorMessage = nil
    }

    // MARK: - Register User
    func registerUser(firstName: String, lastName: String, email: String, password: String) {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required for registration."
            return
        }

        let newUser = fetchOrCreateAuthenticatedUser(
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        currentUser = newUser
        isAuthenticated = true
        errorMessage = nil
    }

    // MARK: - Helper: Fetch or Create Authenticated User
    private func fetchOrCreateAuthenticatedUser(
        firstName: String,
        lastName: String,
        email: String
    ) -> UserModel {
        if let existingUser = container.fetchAllUsers().first(where: { $0.email == email }) {
            return existingUser
        } else {
            let newUser = UserModel(
                firstName: firstName,
                lastName: lastName,
                email: email,
                isGuest: false
            )
            container.context.insert(newUser)
            container.saveContext()
            return newUser
        }
    }
}
