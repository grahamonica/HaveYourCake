//
//  ContentView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigateToHome: Bool = false

    var body: some View {
        NavigationView {
            if navigateToHome {
                HomeView()
                    .onAppear {
                        print("Navigated to HomeView.")
                    }
            } else {
                MainLoginView(navigateToHome: $navigateToHome)
                    .onAppear {
                        print("Navigated to MainLoginView.")
                    }
            }
        }
        .onAppear {
            checkIfUserIsLoggedIn()
        }
    }

    // MARK: - Check User Login State
    private func checkIfUserIsLoggedIn() {
        let container = PersistentContainer.shared
        if let guestUser = container.fetchGuestUser() {
            navigateToHome = true
            print("Guest user found. Navigate to HomeView.")
        } else if !container.fetchAllUsers().isEmpty {
            navigateToHome = true
            print("Authenticated user found. Navigate to HomeView.")
        } else {
            navigateToHome = false
            print("No logged-in user. Stay on MainLoginView.")
        }
    }
}
