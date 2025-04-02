//
//  MainResponseModel.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import Foundation

// MARK: - Model
struct MainResponse: Codable {
    let info: Info?
    let results: [Characters]?
    
    enum CodingKeys: CodingKey {
        case info
        case results
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.info = try? container.decodeIfPresent(Info.self, forKey: .info)
        self.results = try? container.decodeIfPresent([Characters].self, forKey: .results)
    }
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
}

// MARK: - Result
struct Characters: Identifiable, Codable {
    let id: Int?
    let name: String?
    let status: Status?
    let species: Species?
    let type: String?
    let gender: Gender?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.status = try? container.decodeIfPresent(Status.self, forKey: .status)
        self.species = try? container.decodeIfPresent(Species.self, forKey: .species)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.gender = try? container.decodeIfPresent(Gender.self, forKey: .gender)
        self.origin = try? container.decodeIfPresent(Location.self, forKey: .origin)
        self.location = try? container.decodeIfPresent(Location.self, forKey: .location)
        self.image = try? container.decodeIfPresent(String.self, forKey: .image)
        self.episode = try? container.decodeIfPresent([String].self, forKey: .episode)
        self.url = try? container.decodeIfPresent(String.self, forKey: .url)
        self.created = try? container.decodeIfPresent(String.self, forKey: .created)
    }
    
    init(
        id: Int?,
        name: String?,
        status: Status?,
        species: Species?,
        type: String?,
        gender: Gender?,
        origin: Location?,
        location: Location?,
        image: String?,
        episode: [String]?,
        url: String?,
        created: String?
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

enum Species: String, Codable {
    case alien = "Alien"
    case human = "Human"
    case humanoid = "Humanoid"
    case mythologicalCreature = "Mythological Creature"
    case poopybutthole = "Poopybutthole"
    case unknown = "unknown"
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
