//
//  APIService.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation

protocol APIServiceProtocol {
    func fetchCharacters(searchText: String) async throws -> [Characters]
}

final class APIService: APIServiceProtocol {
    func fetchCharacters(searchText: String) async throws -> [Characters] {
        let query = searchText.isEmpty ? "" : "?name=\(searchText.lowercased())"
        let urlString = "https://rickandmortyapi.com/api/character/\(query)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MainResponse.self, from: data)
        return decoded.results ?? []
    }
}
