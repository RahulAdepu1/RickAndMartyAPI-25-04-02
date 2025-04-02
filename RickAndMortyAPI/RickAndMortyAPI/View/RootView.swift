//
//  RootView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SimpleSearchBarView(text: $viewModel.searchText)
                
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
            Text("Try again please!")
        }
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
            }
            .listStyle(PlainListStyle())
        }
        // If the list is Empty
        else {
            VStack {
                Text("No Results")
                Text("Try another search!")
            }
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    RootView()
}
