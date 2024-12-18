//
//  HomeViewModel.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import Foundation
import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var lists: [ListModel] = [] // Active Lists
    @Published var recentlyDeletedLists: [ListModel] = [] // Recently Deleted Lists
    @Published var errorMessage: String? = nil
    @Published var showMenu: Bool = false
    @Published var searchQuery: String = "" // Search Query for filtering
    private var user: UserModel? // Reference to the current user
    private var hasLoadedData = false
    let maxListsPerPie = 8 // Maximum number of slices per pie chart

    private let container = PersistentContainer.shared

    // MARK: - Computed Property for Pie Chart Data
    var pieSlices: [[PieSliceData]] {
        guard !lists.isEmpty else { return [] }

        var slices: [[PieSliceData]] = []
        let totalPies = (lists.count + maxListsPerPie - 1) / maxListsPerPie

        for pieIndex in 0..<totalPies {
            let start = pieIndex * maxListsPerPie
            let end = min(start + maxListsPerPie, lists.count)
            let sliceData = lists[start..<end].enumerated().map { index, list in
                PieSliceData(
                    startAngle: .degrees(Double(index) * 360.0 / Double(end - start)),
                    endAngle: .degrees(Double(index + 1) * 360.0 / Double(end - start)),
                    color: colorForIndex(index),
                    label: list.title
                )
            }
            slices.append(sliceData)
        }
        return slices
    }

    // MARK: - Initialization
    init() {
        setupUser()
        loadDataIfNeeded()
    }

    // MARK: - Setup User
    private func setupUser() {
        // Fetch or create the current user
        if let guestUser = container.fetchGuestUser() {
            user = guestUser
        } else {
            let newGuest = UserModel(isGuest: true)
            container.context.insert(newGuest)
            container.saveContext()
            user = newGuest
        }
    }

    // MARK: - Load Data
    func loadDataIfNeeded() {
        guard !hasLoadedData else { return }
        loadData()
        hasLoadedData = true
    }

    private func loadData() {
        guard let user = user else {
            errorMessage = "No active user found."
            return
        }

        lists = container.fetchListsForUser(user).filter { !$0.isDeleted }
        recentlyDeletedLists = container.fetchListsForUser(user).filter { $0.isDeleted }
        print("Loaded lists for user \(user.fullName): \(lists.map { $0.title })")
    }

    // MARK: - Save Data
    private func saveData() {
        container.saveContext()
        print("Data saved successfully.")
    }

    // MARK: - Add List
    func addList(title: String, items: [String]) {
        guard let user = user else {
            errorMessage = "Unable to add list. No active user."
            return
        }

        guard !title.isEmpty else {
            errorMessage = "List title cannot be empty."
            return
        }

        let listItems = items.map { ListModel.ListItem(name: $0) }
        let newList = ListModel(title: title, items: listItems, owner: user)

        container.context.insert(newList)
        lists.append(newList)
        saveData()
        print("Added new list: \(newList.title), Current lists: \(lists.map { $0.title })")
    }

    // MARK: - Restore List
    func restoreList(list: ListModel) {
        guard recentlyDeletedLists.contains(where: { $0.id == list.id }) else {
            errorMessage = "List not found in recently deleted."
            return
        }

        list.isDeleted = false
        lists.append(list)
        recentlyDeletedLists.removeAll { $0.id == list.id }
        saveData()
        print("Restored list: \(list.title)")
    }

    // MARK: - Update List
    func updateList(id: UUID, newTitle: String, newItems: [ListModel.ListItem]) {
        guard let index = lists.firstIndex(where: { $0.id == id }) else {
            errorMessage = "List not found."
            return
        }

        lists[index].title = newTitle
        lists[index].items = newItems
        saveData()
        print("Updated list \(newTitle) with items: \(newItems.map { $0.name })")
    }

    // MARK: - Permanently Delete List
    func permanentlyDeleteList(list: ListModel) {
        guard recentlyDeletedLists.contains(where: { $0.id == list.id }) else {
            errorMessage = "List not found in recently deleted."
            return
        }

        container.delete(list)
        recentlyDeletedLists.removeAll { $0.id == list.id }
        saveData()
        print("Permanently deleted list: \(list.title)")
    }

    // MARK: - Utility: Color Generator
    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .cyan]
        return colors[index % colors.count]
    }
}
