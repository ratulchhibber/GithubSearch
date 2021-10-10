//
//  GithubRepositoryResults.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation

struct GithubRepositoryResults: Codable {
    let totalCount: Int
    var items: [GithubRepositoryResult]
}

struct GithubRepositoryResult: Codable, Identifiable {
    let id: Int
    let name: String
    let language: String?
    let description: String?
    let stargazersCount: Int
    let owner: Owner?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, language, description, stargazersCount, owner, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        owner = try container.decodeIfPresent(Owner.self, forKey: .owner)
        if let dateString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = Date.dateFrom(dateString: dateString)
        } else {
            createdAt = nil
        }
    }
}

struct Owner: Codable {
    let login: String
    let avatarUrl: String
}
