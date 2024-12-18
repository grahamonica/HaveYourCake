//
//  CreateAccountWithUsernameView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI

struct CreateAccountWithUsernameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Input Fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var emailOrPhone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // Validation Error Message
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding()
                }
                Spacer()
            }
            
            // Page Title
            Text("Sign Up with Username")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.pink)
                .padding(.top, 10)
            
            // Input Fields
            VStack(spacing: 15) {
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Email or Phone", text: $emailOrPhone)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                SecureField("Re-enter Password", text: $confirmPassword)
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
            
            // Sign Up Button
            Button(action: {
                validateAndCreateAccount()
            }) {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
    
    // MARK: - Validation and Action
    private func validateAndCreateAccount() {
        if firstName.isEmpty || lastName.isEmpty || emailOrPhone.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all fields."
        } else if password != confirmPassword {
            errorMessage = "Passwords do not match."
        } else {
            // Placeholder for account creation logic
            print("Account created for \(emailOrPhone)")
            errorMessage = ""
        }
    }
}

// MARK: - Preview
struct CreateAccountWithUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccountWithUsernameView()
        }
    }
}
