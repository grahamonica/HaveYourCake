//
//  AccountSettingsView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI

struct AccountSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Text("Account Settings")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    viewModel.logOut()
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                }
                .padding()
            }

            // Settings Options
            List {
                Section(header: Text("Account Actions")) {
                    Button(action: {
                        viewModel.deleteAccount()
                    }) {
                        HStack {
                            Text("Delete Account")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }

                Section(header: Text("Preferences")) {
                    Toggle(isOn: $viewModel.notificationsEnabled) {
                        Text("Enable Notifications")
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .padding()

            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Preview
struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView(viewModel: SettingsViewModel())
    }
}
