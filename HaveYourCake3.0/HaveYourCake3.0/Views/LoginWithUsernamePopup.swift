//
//  LoginWithUsernamePopup.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI

struct LoginWithUsernamePopup: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Input Fields
    @State private var usernameOrEmail: String = ""
    @State private var password: String = ""
    
    // Error Message
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Close Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
            }
            
            // Title
            Text("Login with Username")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            // Input Fields
            VStack(spacing: 15) {
                TextField("Username or Email", text: $usernameOrEmail)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 30)
            
            // Error Message
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Login Button
            Button(action: {
                validateAndLogin()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
    
    // MARK: - Validation and Login
    private func validateAndLogin() {
        if usernameOrEmail.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
        } else {
            // Placeholder for login logic
            print("Logging in with \(usernameOrEmail)")
            errorMessage = ""
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview
struct LoginWithUsernamePopup_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithUsernamePopup()
    }
}
