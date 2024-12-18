//
//  UserModel.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import Foundation
import SwiftData

@Model
class UserModel {
    var id: UUID
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var creationDate: Date
    var isGuest: Bool
    @Relationship var lists: [ListModel] // Lists associated with the user

    init(
        firstName: String? = nil,
        lastName: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil,
        isGuest: Bool = true
    ) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.creationDate = Date()
        self.isGuest = isGuest
        self.lists = [] // Initialize with an empty list array
    }

    // Computed Property: Full Name
    var fullName: String {
        guard let firstName = firstName, let lastName = lastName else {
            return "Guest User"
        }
        return "\(firstName) \(lastName)"
    }
}
