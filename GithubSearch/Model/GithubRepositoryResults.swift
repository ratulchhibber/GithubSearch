//
//  GithubRepositoryResults.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

struct GithubRepositoryResults: Codable {
    var totalCount: Int
    var items: [GithubRepositoryResult]
}

struct GithubRepositoryResult: Codable, Identifiable {
    let id: Int
    let name: String
    let language: String?
    let description: String?
    let stargazersCount: Int
}
