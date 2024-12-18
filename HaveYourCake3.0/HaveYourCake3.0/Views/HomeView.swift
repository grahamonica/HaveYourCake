//
//  HomeView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedList: ListModel?
    @State private var showNewListPopup = false
    @State private var showMenu = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background color setup
                Color(hex: "f0e8e6")
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    headerView

                    Spacer()

                    addListButton

                    Spacer()

                    pieChartsView

                    Spacer()
                }

                if showMenu {
                    menuView
                }
            }
            .sheet(item: $selectedList) { list in
                EditListView(viewModel: viewModel, list: list)
            }
            .onAppear {
                viewModel.loadDataIfNeeded()
            }
        }
    }

    // MARK: - Simplified Views

    private var headerView: some View {
        HStack {
            Button(action: { showMenu.toggle() }) {
                Image(systemName: "line.3.horizontal")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
            }
            Spacer()
            SearchView(
                query: $viewModel.searchQuery,
                allLists: viewModel.lists,
                onListSelected: { selectedList = $0 }
            )
            .padding(.trailing, 10)
        }
    }

    private var addListButton: some View {
        Button(action: { showNewListPopup.toggle() }) {
            ZStack {
                Circle()
                    .fill(Color(hex: "A7C7E7"))
                    .frame(width: 40, height: 40)
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
        }
        .padding()
        .sheet(isPresented: $showNewListPopup) {
            NewListPopup(viewModel: viewModel)
        }
    }

    private var pieChartsView: some View {
        ScrollView {
            ForEach(0..<viewModel.pieSlices.count, id: \.self) { pieIndex in
                PieChartView(
                    slices: viewModel.pieSlices[pieIndex],
                    onSliceTapped: { sliceIndex in
                        let listIndex = pieIndex * viewModel.maxListsPerPie + sliceIndex
                        if listIndex < viewModel.lists.count {
                            selectedList = viewModel.lists[listIndex]
                        }
                    }
                )
                .frame(width: 300, height: 300)
                .padding()
            }
        }
    }

    private var menuView: some View {
        MenuView(
            isOpen: $showMenu,
            homeViewModel: viewModel, // Pass the existing HomeViewModel instance
            settingsViewModel: SettingsViewModel() // Initialize a new SettingsViewModel
        )
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
