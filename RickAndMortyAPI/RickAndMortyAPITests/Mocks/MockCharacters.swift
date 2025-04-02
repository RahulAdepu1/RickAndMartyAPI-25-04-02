//
//  MockCharacters.swift
//  RickAndMortyAPITests
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation
@testable import RickAndMortyAPI

let mockCharacter = Characters(
    id: 1,
    name: "Rick Sanchez",
    status: .alive,
    species: .human,
    type: "",
    gender: .male,
    origin: Location(name: "Earth", url: ""),
    location: Location(name: "Citadel of Ricks", url: ""),
    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
    episode: [],
    url: nil,
    created: "2017-11-04T18:48:46.250Z"
)

let mockCharacterList: [Characters] = [mockCharacter]
