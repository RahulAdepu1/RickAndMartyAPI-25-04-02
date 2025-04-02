//
//  RootViewModel.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation
import Combine

// Variable declaration, initializers and deinitializer
final class RootViewModel: ObservableObject {
    @Published var characters: [Characters] = []
    @Published var searchText: String = ""
    @Published var viewState: RootViewState = .idle

    private let fetchCharactersUseCase: FetchCharactersUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchCharactersUseCase: FetchCharactersUseCase = CharacterRepository()) {
        self.fetchCharactersUseCase = fetchCharactersUseCase
        observeSearchText()
    }
}

// Fetch Data
extension RootViewModel {
    private func observeSearchText() {
        $searchText
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.fetchCharacters(searchText: query)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchCharacters(searchText: String) async {
        updateState(newState: .loading)
        
        do {
            let results = try await fetchCharactersUseCase.execute(searchText: searchText)
            characters = results
            updateState(newState: .loaded)
        } catch {
            characters = []
            updateState(newState: .error)
        }
    }
}

// View State Update
extension RootViewModel {
    enum RootViewState {
        case idle
        case loading
        case loaded
        case error
    }
    
    @MainActor
    private func updateState(newState: RootViewState) {
        self.viewState = newState
    }
}
