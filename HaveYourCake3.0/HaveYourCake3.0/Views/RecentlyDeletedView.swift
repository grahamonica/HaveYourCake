//
//  RecentlyDeletedView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI

struct RecentlyDeletedView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.recentlyDeletedLists.isEmpty {
                    // Empty State View
                    Text("No recently deleted lists.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // List of Recently Deleted Lists
                    List {
                        ForEach(viewModel.recentlyDeletedLists, id: \.id) { list in
                            HStack {
                                Text(list.title)
                                    .font(.body)
                                    .lineLimit(1)
                                
                                Spacer()

                                // Restore Button
                                Button(action: {
                                    restoreList(list)
                                }) {
                                    Text("Restore")
                                        .foregroundColor(.blue)
                                }

                                // Permanently Delete Button
                                Button(action: {
                                    permanentlyDeleteList(list)
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Recently Deleted")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }

    // MARK: - Functions
    private func restoreList(_ list: ListModel) {
        print("Restoring list: \(list.title)")
        viewModel.restoreList(list: list)
    }

    private func permanentlyDeleteList(_ list: ListModel) {
        print("Permanently deleting list: \(list.title)")
        viewModel.permanentlyDeleteList(list: list)
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let listToDelete = viewModel.recentlyDeletedLists[index]
            print("Deleting via swipe: \(listToDelete.title)")
            viewModel.permanentlyDeleteList(list: listToDelete)
        }
    }
}
