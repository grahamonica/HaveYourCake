//
//  App.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI
import SwiftData

@main
struct HaveYourCakeApp: App {
    @Environment(\.scenePhase) var scenePhase
    private let container = PersistentContainer.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, container.context) // Provide the ModelContext
        }
        .modelContainer(for: [UserModel.self, ListModel.self]) // Attach ModelContainer
        .onChange(of: scenePhase) { phase in
            if phase == .background || phase == .inactive {
                container.saveContext()
            }
        }
    }
}
