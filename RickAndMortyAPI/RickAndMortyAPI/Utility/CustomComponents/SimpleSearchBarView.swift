//
//  SimpleSearchBarView.swift
//  RickAndMortyAPI
//
//  Created by Rahul Adepu on 4/2/25.
//

import SwiftUI

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

#Preview {
    SimpleSearchBarView()
}
