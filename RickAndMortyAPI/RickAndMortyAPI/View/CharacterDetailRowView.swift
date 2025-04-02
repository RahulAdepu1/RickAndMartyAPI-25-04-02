//
//  CharacterDetailRowView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

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
