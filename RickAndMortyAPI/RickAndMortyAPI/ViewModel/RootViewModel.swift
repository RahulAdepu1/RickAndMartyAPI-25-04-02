//
//  RootViewModel.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation
import Combine

// Variable declaration, initializers and deinitializer
class RootViewViewModel: ObservableObject {
    @Published var characters: [Characters] = []
    @Published var searchText: String = ""
    @Published var viewState: RootViewState = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchData()
    }
    
    deinit {
        
    }
}

// Fetch Data
extension RootViewViewModel {
    func fetchData() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                self.fetchCharacters(searchText: query)
            }
            .store(in: &cancellables)
    }
    
    func fetchCharacters(searchText: String) {
        updateState(newState: .loading)
        
        let searchTextLowered = searchText.lowercased()
        let query = searchTextLowered.isEmpty ? "" : "?name=\(searchTextLowered)"
        
        // get url
        let baseURL = "https://rickandmortyapi.com/api/character/"
        guard let url = URL(string: "\(baseURL)\(query)") else {
            updateState(newState: .error)
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MainResponse.self, decoder: JSONDecoder())
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.updateState(newState: .loaded)
                if case .failure(_) = completion {
                    self.characters = []
                }
            }, receiveValue: { [weak self] characters in
                guard let self = self else { return }
                self.characters = characters ?? []
            })
            .store(in: &cancellables)
    }
}

// View State Update
extension RootViewViewModel {
    enum RootViewState {
        case idle
        case loading
        case loaded
        case error
    }
    
    private func updateState(newState: RootViewState) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewState = newState
        }
    }
}
