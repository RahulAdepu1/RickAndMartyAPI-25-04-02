//
//  RootView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SimpleSearchBarView(text: $viewModel.searchText)
                    .accessibilityLabel("Search for Rick and Morty characters")
                
                // View States
                if viewModel.viewState == .idle || viewModel.viewState == .loading {
                    progressiveView()
                } else if viewModel.viewState == .loaded {
                    loadedView()
                } else if viewModel.viewState == .error {
                    errorView()
                }
            }
            .navigationTitle("Rick & Morty")
            .accessibilityAddTraits(.isHeader)
        }
    }
}

extension RootView {
    // Progessive View during idle state and loading state
    func progressiveView() -> some View {
        ZStack {
            ProgressView("Loading...")
        }
        .padding(.bottom, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Error View to present error
    func errorView() -> some View {
        ZStack {
            Text("Congratulations you found an ERROR")
                .accessibilityLabel("Congratulations you found an ERROR")
            Text("Try again please!")
                .accessibilityHint("Try again please!")
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("ErrorMessage")
        .padding(.bottom, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func loadedView() -> some View {
        // If the list is not Empty
        if !viewModel.characters.isEmpty {
            List(viewModel.characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    CharacterRowView(character: character)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(character.name ?? "Unknown character")")
                .accessibilityAddTraits(.isButton)
            }
            .listStyle(PlainListStyle())
            .accessibilityIdentifier("CharacterList")
        }
        // If the list is Empty
        else {
            VStack {
                Text("No Results")
                    .accessibilityLabel("No results found")
                Text("Try another search!")
                    .accessibilityHint("Try another search!")
            }
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("EmptyResultView")
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    RootView()
}
