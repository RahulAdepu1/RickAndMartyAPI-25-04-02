//
//  ContentView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI
import Combine

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
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
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

// MARK: - ViewModel
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


// MARK: - View
struct RootView: View {
    @StateObject private var viewModel = RootViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SimpleSearchBarView(text: $viewModel.searchText)
                
                // View States
                if viewModel.viewState == .idle || viewModel.viewState == .loading {
                    progressiveView()
                } else if viewModel.viewState == .loaded {
                    loadedView()
                } else if viewModel.viewState == .error {
                    errorView()
                }
            }
            .navigationTitle("Rick & Morty")
        }
    }
}

extension RootView {
    // Progessive View during idle state and loading state
    func progressiveView() -> some View {
        ZStack {
            ProgressView("Loading...")
        }
        .padding(.bottom, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // Error View to present error
    func errorView() -> some View {
        ZStack {
            Text("Congratulations you found an ERROR")
            Text("Try again please!")
        }
        .padding(.bottom, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func loadedView() -> some View {
        // If the list is not Empty
        if !viewModel.characters.isEmpty {
            List(viewModel.characters) { character in
                NavigationLink(destination: CharacterDetailView(character: character)) {
                    CharacterRowView(character: character)
                }
            }
            .listStyle(PlainListStyle())
        }
        // If the list is Empty
        else {
            VStack {
                Text("No Results")
                Text("Try another search!")
            }
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct CharacterRowView: View {
    let character: Characters

    var body: some View {
        HStack {
            // Character Image
            AsyncImage(url: URL(string: character.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())

            // Character Brief Info
            VStack(alignment: .leading) {
                Text(character.name ?? "")
                    .font(.headline)
                Text(character.species?.rawValue ?? "")
                    .font(.subheadline)
            }
        }
    }
}

struct CharacterDetailView: View {
    let character: Characters

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Character Image
                AsyncImage(url: URL(string: character.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 16)

                // Character Species, Status, and Origin
                CharacterDetailRowView(title: "Species", value: character.species?.rawValue ?? "")
                CharacterDetailRowView(title: "Status", value: character.status?.rawValue ?? "")
                CharacterDetailRowView(title: "Origin", value: character.origin?.name ?? "")

                // Character type
                if ((character.type?.isEmpty) == nil) {
                    CharacterDetailRowView(title: "Type", value: character.type ?? "")
                }

                CharacterDetailRowView(title: "Created", value: character.created?.formattedDate() ?? "")
            }
            .padding()
        }
        .navigationTitle(character.name ?? "")
    }
}

struct CharacterDetailRowView: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .bold()
            Text(value)
        }
        .padding(.vertical, 2)
    }
}

struct SimpleSearchBarView: View {
    @Binding var text: String

    var body: some View {
        TextField("Search Characters...", text: $text)
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
    }
}

extension String {
    // function to convert the iso format date to regular date format
    func formattedDate() -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        guard let date = inputDateFormatter.date(from: self) else {
            return "Date Error"
        }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MMM dd, yyyy"
        outputDateFormatter.locale = Locale(identifier: "en_US")
        
        return outputDateFormatter.string(from: date)
    }
}

#Preview {
    RootView()
}
