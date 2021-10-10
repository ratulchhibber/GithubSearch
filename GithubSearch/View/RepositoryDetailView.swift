//
//  RepositoryDetailView.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 10/10/21.
//

import SwiftUI

struct RepositoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    let repository: GithubRepositoryResult

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Name:")
                    .font(.title3)
                Spacer()
                Text(repository.name)
            }
            
            HStack {
                Text("Language:")
                    .font(.title3)
                Spacer()
                Text(repository.language ?? "")
            }
            
            HStack {
                Text("⭐️")
                    .font(.title3)
                Spacer()
                Text("\(repository.stargazersCount)")
            }
        }
        .padding(.horizontal, 20)
    }
}
