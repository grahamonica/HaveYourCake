//
//  Constants.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import Foundation
import SwiftUI

struct Constants {
    // MARK: - App Metadata
    static let appName = "HaveYourCake3.0"
    static let version = "1.0.0"

    // MARK: - Colors
    struct Colors {
        static let primaryColor = Color.pink
        static let secondaryColor = Color.blue
        static let backgroundColor = Color.white
        static let textColor = Color.black
        static let errorColor = Color.red
    }

    // MARK: - Firebase Keys
    struct FirebaseKeys {
        static let userCollection = "users"
        static let listCollection = "lists"
    }

    // MARK: - Layout Dimensions
    struct Layout {
        static let cornerRadius: CGFloat = 8.0
        static let buttonHeight: CGFloat = 50.0
        static let padding: CGFloat = 16.0
        static let spacing: CGFloat = 10.0
    }

    // MARK: - Placeholder Texts
    struct Placeholders {
        static let username = "Enter your username"
        static let email = "Enter your email"
        static let password = "Enter your password"
        static let listTitle = "List title"
        static let listItem = "Add a new item"
    }

    // MARK: - Error Messages
    struct Errors {
        static let genericError = "Something went wrong. Please try again."
        static let emptyFieldsError = "Please fill in all required fields."
    }

    // MARK: - Icons
    struct Icons {
        static let backButton = "chevron.left"
        static let deleteButton = "trash"
        static let addButton = "plus"
        static let shareButton = "square.and.arrow.up"
    }
    
}
