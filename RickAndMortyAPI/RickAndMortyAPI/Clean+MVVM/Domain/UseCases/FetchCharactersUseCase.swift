//
//  FetchCharactersUseCase.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation

protocol FetchCharactersUseCase {
    func execute(searchText: String) async throws -> [Characters]
}
