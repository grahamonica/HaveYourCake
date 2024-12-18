//
//  CreateAccountView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToCreateWithUsername = false
    
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
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.pink)
                .padding(.top, 20)
            
            // Account Creation Buttons
            VStack(spacing: 15) {
                Button(action: {
                    // Placeholder for Google Signup
                }) {
                    Text("Sign up with Google")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Placeholder for Apple Signup
                }) {
                    Text("Sign up with Apple")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    navigateToCreateWithUsername = true
                }) {
                    Text("Sign up with Username")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 10)
            
            Spacer()
            
            // Navigation Link to Username Signup Page
            NavigationLink(
                destination: CreateAccountWithUsernameView(),
                isActive: $navigateToCreateWithUsername
            ) {
                EmptyView()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

// Preview
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CreateAccountView()
        }
    }
}
