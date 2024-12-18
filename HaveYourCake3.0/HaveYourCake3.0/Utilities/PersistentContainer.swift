//
//  PersistentContainer.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/19/24.
//
import Foundation
import SwiftData

final class PersistentContainer {
    static let shared = PersistentContainer() // Singleton instance

    private var container: ModelContainer?

    private init() {
        do {
            // Use variadic arguments for models
            container = try ModelContainer(for: UserModel.self, ListModel.self)
            print("PersistentContainer initialized successfully.")
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }

    // MARK: - Access ModelContext
    @MainActor
    var context: ModelContext {
        guard let container = container else {
            fatalError("ModelContainer is not initialized.")
        }
        return container.mainContext
    }

    // MARK: - Save Changes
    @MainActor
    func saveContext() {
        do {
            try context.save()
            print("Changes successfully saved to persistent storage.")
        } catch {
            print("Failed to save changes: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Data
    @MainActor
    func fetchAllUsers() -> [UserModel] {
        let fetchDescriptor = FetchDescriptor<UserModel>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch UserModel data: \(error.localizedDescription)")
            return []
        }
    }

    @MainActor
    func fetchGuestUser() -> UserModel? {
        let fetchDescriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { user in
                user.isGuest
            }
        )
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch guest user: \(error.localizedDescription)")
            return nil
        }
    }

    @MainActor
    func fetchUserByID(_ id: UUID) -> UserModel? {
        let fetchDescriptor = FetchDescriptor<UserModel>(
            predicate: #Predicate { user in
                user.id == id
            }
        )
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch UserModel by ID \(id): \(error.localizedDescription)")
            return nil
        }
    }

    @MainActor
    func fetchListsForUser(_ user: UserModel) -> [ListModel] {
        let fetchDescriptor = FetchDescriptor<ListModel>() // Fetch all lists

        do {
            let allLists = try context.fetch(fetchDescriptor)
            return allLists.filter { $0.owner?.id == user.id } // Filter in memory
        } catch {
            print("Failed to fetch lists for user \(user.fullName): \(error.localizedDescription)")
            return []
        }
    }
    // MARK: - Delete Data
    @MainActor
    func delete(_ object: any PersistentModel) {
        context.delete(object)
        saveContext()
    }

    // MARK: - Utility
    @MainActor
    func resetGuestData() {
        guard let guestUser = fetchGuestUser() else {
            print("No guest user found to reset.")
            return
        }
        context.delete(guestUser)
        saveContext()
        print("Guest data cleared.")
    }
}
