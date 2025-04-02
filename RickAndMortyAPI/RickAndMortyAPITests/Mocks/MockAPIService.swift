//
//  MockAPIService.swift
//  RickAndMortyAPITests
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation
@testable import RickAndMortyAPI

final class MockAPIService: APIServiceProtocol {
    var shouldThrowError = false
    var returnEmpty = false

    func fetchCharacters(searchText: String) async throws -> [Characters] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }

        return returnEmpty ? [] : mockCharacterList
    }
}
