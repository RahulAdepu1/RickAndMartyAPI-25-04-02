//
//  CharacterRepository.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation

final class CharacterRepository: FetchCharactersUseCase {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func execute(searchText: String) async throws -> [Characters] {
        return try await apiService.fetchCharacters(searchText: searchText)
    }
}
