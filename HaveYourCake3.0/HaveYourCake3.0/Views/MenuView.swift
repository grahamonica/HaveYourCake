//
//  MenuView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI

struct MenuView: View {
    @Binding var isOpen: Bool
    
    // ViewModels
    var homeViewModel: HomeViewModel
    var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            if isOpen {
                // Background overlay to close menu
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
                
                // Slide-out menu
                VStack(alignment: .leading, spacing: 20) {
                    Button(action: {
                        isOpen = false
                        // Direct navigation to HomeView
                        navigate(to: HomeView())
                    }) {
                        HStack {
                            Image(systemName: "house")
                            Text("Home")
                                .font(.headline)
                        }
                        .padding()
                    }

                    Button(action: {
                        isOpen = false
                        // Direct navigation to AccountSettingsView
                        navigate(to: AccountSettingsView(viewModel: settingsViewModel))
                    }) {
                        HStack {
                            Image(systemName: "gear")
                            Text("Account Settings")
                                .font(.headline)
                        }
                        .padding()
                    }

                    Button(action: {
                        isOpen = false
                        // Direct navigation to RecentlyDeletedView
                        navigate(to: RecentlyDeletedView(viewModel: homeViewModel))
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Recently Deleted")
                                .font(.headline)
                        }
                        .padding()
                    }
                    
                    Button(action: {
                        isOpen = false
                        // Direct navigation to ContactUsView
                        navigate(to: ContactUsView())
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                            Text("Contact Us")
                                .font(.headline)
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .frame(width: 250)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .offset(x: 0)
                .transition(.move(edge: .leading))
            }
        }
    }
    
    /// Directly navigates to the specified view.
    /// - Parameter view: The destination view.
    private func navigate<Destination: View>(to view: Destination) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let hostingController = UIHostingController(rootView: view)
            rootViewController.present(hostingController, animated: true)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isOpen: .constant(true),
                 homeViewModel: HomeViewModel(),
                 settingsViewModel: SettingsViewModel())
    }
}
