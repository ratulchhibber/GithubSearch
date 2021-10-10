//
//  RepositoryDetailView.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 10/10/21.
//

import SwiftUI

struct RepositoryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var userChoice: [Int: Choice]
    let repository: GithubRepositoryResult

    var body: some View {
        NavigationView {
            contentView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private func contentView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if let url = repository.owner?.avatarUrl {
                avatarView(for: url)
            }
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
            
            if previousChoice != .none {
                infoRow(title: "Previous choice:",
                        detail: "\(previousChoice)")
            }
            
            selectUserChoiceRow()
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
    
    @ViewBuilder
    private func selectUserChoiceRow() -> some View {
        HStack(spacing: 20) {
            Spacer()
            Button(Choice.like.description) {
                userChoice[repository.id] = .like
                dismiss()
            }.font(.largeTitle)
            Spacer()
            Button(Choice.dislike.description) {
                userChoice[repository.id] = .dislike
                dismiss()
            }.font(.largeTitle)
            Spacer()
        }
        .padding(.top)
        .padding()
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

extension RepositoryDetailView {
    
    private var previousChoice: Choice { userChoice[repository.id] ?? .none }
    
    private var creationDate: String {
        if let date = repository.createdAt {
            return Date.stringFrom(date: date)
        }
        return ""
    }
}
