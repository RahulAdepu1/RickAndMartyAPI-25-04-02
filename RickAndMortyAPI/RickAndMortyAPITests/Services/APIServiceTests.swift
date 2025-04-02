//
//  APIServiceTests.swift
//  RickAndMortyAPITests
//
//  Created by Rahul Adepu on 4/2/25.
//

import XCTest
@testable import RickAndMortyAPI

final class APIServiceTests: XCTestCase {
    let apiService = MockAPIService()

    func testFetchCharacters_Success() async throws {
        let characters = try await apiService.fetchCharacters(searchText: "rick")

        XCTAssertFalse(characters.isEmpty)
        XCTAssertTrue(characters.contains { $0.name?.lowercased().contains("rick") ?? false })
    }

    func testFetchCharacters_EmptySearchReturnsAll() async throws {
        let characters = try await apiService.fetchCharacters(searchText: "")

        XCTAssertFalse(characters.isEmpty)
    }
}

final class BadURLAPIService: APIServiceProtocol {
    func fetchCharacters(searchText: String) async throws -> [Characters] {
        throw URLError(.badURL)
    }
}
