//
//  SettingsViewModel.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isAccountDeleted: Bool = false
    @Published var errorMessage: String? = nil
    @Published var notificationsEnabled: Bool = true // Added property for notifications toggle

    // Dependency Injection for User Management
    @Published var currentUser: UserModel?

    // MARK: - Methods

    func toggleNotifications() {
        notificationsEnabled.toggle()
    }

    func deleteAccount() {
        guard let user = currentUser else {
            errorMessage = "No user is currently logged in."
            return
        }

        if user.isGuest {
            // Show message to guest users
            errorMessage = "Guest accounts cannot be deleted. Please log in or create an account."
        } else {
            // Simulate deleting an account
            isAccountDeleted = true
            currentUser = nil
            errorMessage = nil
        }
    }

    func logOut() {
        currentUser = nil
        isAccountDeleted = false
        errorMessage = nil
    }

    func updateProfile(firstName: String?, lastName: String?, email: String?) {
        guard currentUser != nil else {
            errorMessage = "No user is currently logged in."
            return
        }

        if let firstName = firstName, !firstName.isEmpty {
            currentUser?.firstName = firstName
        }

        if let lastName = lastName, !lastName.isEmpty {
            currentUser?.lastName = lastName
        }

        if let email = email, !email.isEmpty {
            if isValidEmail(email) {
                currentUser?.email = email
            } else {
                errorMessage = "Invalid email format."
                return
            }
        }

        errorMessage = nil
    }

    // MARK: - Helpers
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
