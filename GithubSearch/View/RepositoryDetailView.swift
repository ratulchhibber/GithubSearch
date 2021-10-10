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
            infoRow(title: "Owner's login:",
                    detail: repository.owner?.login ?? "")
            infoRow(title: "Creation date:",
                    detail: creationDate)
            infoRow(title: "Name:",
                    detail: repository.name)
            infoRow(title: "Language:",
                    detail: repository.language ?? "")
            infoRow(title: "⭐️",
                    detail: "\(repository.stargazersCount)")
        }
        .padding(.horizontal, 20)
    }
        
    @ViewBuilder
    private func infoRow(title: String, detail: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
            Spacer()
            Text(detail)
        }
    }
    
    private var creationDate: String {
        if let date = repository.createdAt {
            return Date.stringFrom(date: date)
        }
        return ""
    }
}
