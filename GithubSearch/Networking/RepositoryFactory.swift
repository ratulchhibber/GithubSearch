//
//  RepositoryFactory.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation

final class RepositoryFactory {
    private init() {}
    
    static func githubSearchRepository(for configuration: WebRepository) -> GithubSearchWebRepositoryConfigurable {
        return GithubSearchWebRepository(session: configuration.session,
                                         baseURL: configuration.baseURL)
    }
}
