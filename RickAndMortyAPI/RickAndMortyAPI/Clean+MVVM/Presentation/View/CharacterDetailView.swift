//
//  CharacterDetailView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

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
