///
//  ListModel.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import Foundation
import SwiftData

@Model
class ListModel {
    var id: UUID
    var title: String
    var items: [ListItem] // Embedded ListItem model
    var creationDate: Date
    var isDeleted: Bool
    var owner: UserModel? // Relationship with UserModel

    init(title: String, items: [ListItem] = [], owner: UserModel? = nil) {
        self.id = UUID()
        self.title = title
        self.items = items
        self.creationDate = Date()
        self.isDeleted = false
        self.owner = owner
    }

    // MARK: - Embedded ListItem Model
    @Model
    class ListItem {
        var id: UUID
        var name: String

        init(name: String) {
            self.id = UUID()
            self.name = name
        }
    }
}
