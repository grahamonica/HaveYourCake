//
//  EditListView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//

import SwiftUI
import SwiftData

struct EditListView: View {
    @Environment(\.modelContext) private var context: ModelContext // Access SwiftData context
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    @State private var listTitle: String
    @State private var listItems: [ListModel.ListItem]

    var list: ListModel

    // MARK: - Initializer
    init(viewModel: HomeViewModel, list: ListModel) {
        self.viewModel = viewModel
        self._listTitle = State(initialValue: list.title)
        self._listItems = State(initialValue: list.items)
        self.list = list
    }

    // MARK: - Body
    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: saveChanges) {
                    Text("Save")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding()

            // Title Input
            TextField("List Title", text: $listTitle)
                .keyboardType(.default)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)

            // List Items
            List {
                ForEach(listItems.indices, id: \.self) { index in
                    HStack {
                        TextField("Item \(index + 1)", text: Binding(
                            get: { listItems[index].name },
                            set: { listItems[index].name = $0 }
                        ))
                        .keyboardType(.default)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                        if listItems.count > 1 {
                            Button(action: {
                                deleteItem(at: index)
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onMove(perform: moveItem)
            }
            .listStyle(PlainListStyle())
            .environment(\.editMode, .constant(.active))

            // Add Item Button
            Button(action: addItem) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Item")
                }
                .foregroundColor(.blue)
                .padding()
            }

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Edit List")
        .navigationBarHidden(true)
    }

    // MARK: - Functions
    private func saveChanges() {
        guard !listTitle.isEmpty else {
            print("List title cannot be empty.")
            return
        }

        let filteredItems = listItems.filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
        list.title = listTitle
        list.items = filteredItems

        do {
            try context.save()
            viewModel.loadDataIfNeeded() // Refresh the view model
            print("Changes saved successfully.")
        } catch {
            print("Failed to save changes: \(error.localizedDescription)")
        }
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteItem(at index: Int) {
        guard index >= 0 && index < listItems.count else { return }
        listItems.remove(at: index)
    }

    private func addItem() {
        listItems.append(ListModel.ListItem(name: "New Item"))
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        listItems.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: - Preview
struct EditListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleList = ListModel(title: "Groceries", items: [
            ListModel.ListItem(name: "Milk"),
            ListModel.ListItem(name: "Eggs")
        ])
        EditListView(viewModel: HomeViewModel(), list: sampleList)
    }
}
