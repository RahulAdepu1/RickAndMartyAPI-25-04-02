//
//  CharacterRowView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

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

#Preview {
    CharacterRowView()
}
