//
//  RootViewModelTests.swift
//  RickAndMortyAPITests
//
//  Created by Rahul Adepu on 4/2/25.
//

import XCTest
@testable import RickAndMortyAPI

@MainActor
final class RootViewModelTests: XCTestCase {
    var viewModel: RootViewModel!
    var mockUseCase: MockFetchCharactersUseCase!

    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchCharactersUseCase()
        viewModel = RootViewModel(fetchCharactersUseCase: mockUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        super.tearDown()
    }

    func testFetchCharacters_Success() async {
        await viewModel.fetchCharacters(searchText: "rick")

        XCTAssertEqual(viewModel.characters.count, 1)
        XCTAssertEqual(viewModel.characters.first?.name, "Rick Sanchez")
        XCTAssertEqual(viewModel.viewState, .loaded)
    }

    func testFetchCharacters_EmptyResults() async {
        mockUseCase.returnEmpty = true
        await viewModel.fetchCharacters(searchText: "unknown")

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertEqual(viewModel.viewState, .loaded)
    }

    func testFetchCharacters_Failure() async {
        mockUseCase.shouldThrowError = true
        await viewModel.fetchCharacters(searchText: "rick")

        XCTAssertTrue(viewModel.characters.isEmpty)
        XCTAssertEqual(viewModel.viewState, .error)
    }
}
