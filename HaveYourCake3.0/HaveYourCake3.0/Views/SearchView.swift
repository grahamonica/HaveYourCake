
//  SearchView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI

struct SearchView: View {
    @Binding var query: String
    var allLists: [ListModel]
    var onListSelected: (ListModel) -> Void

    var filteredLists: [ListModel] {
        guard !query.isEmpty else { return allLists }
        return allLists.filter { list in
            list.title.localizedCaseInsensitiveContains(query) ||
            list.items.contains { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }

    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search lists...", text: $query)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Spacer()
                            if !query.isEmpty {
                                Button(action: {
                                    query = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            // Filtered Results
            if filteredLists.isEmpty {
                Text("No results found.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(filteredLists, id: \.id) { list in
                    Button(action: {
                        onListSelected(list)
                    }) {
                        HStack {
                            Text(list.title)
                                .font(.body)
                            Spacer()
                            Text("\(list.items.count) items")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

// MARK: - Preview
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchQuery = ""
        let sampleLists = [
            ListModel(title: "Groceries", items: [ListModel.ListItem(name: "Milk"), ListModel.ListItem(name: "Eggs")]),
            ListModel(title: "Work", items: [ListModel.ListItem(name: "Emails"), ListModel.ListItem(name: "Presentation")]),
            ListModel(title: "Travel", items: [ListModel.ListItem(name: "Flights"), ListModel.ListItem(name: "Hotels")])
        ]

        SearchView(query: $searchQuery, allLists: sampleLists, onListSelected: { _ in })
    }
}
