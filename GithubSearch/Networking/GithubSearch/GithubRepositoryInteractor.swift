//
//  RepositoryFactory.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation
import Combine

protocol GithubRepositoryInteractorCustomizable {
    func searchRepository(for query: GithubSearchQueryCustomizable) -> AnyPublisher<GithubRepositoryResults, Error>
}

final class GithubRepositoryInteractor: GithubRepositoryInteractorCustomizable {
    let webRepository: GithubSearchWebRepositoryConfigurable
    
    init(webRepository: GithubSearchWebRepositoryConfigurable) {
        self.webRepository = webRepository
    }
    
    func searchRepository(for query: GithubSearchQueryCustomizable) -> AnyPublisher<GithubRepositoryResults, Error> {
        return webRepository.searchRepository(for: query)
    }
}

struct StubGithubRepositoryInteractor: GithubRepositoryInteractorCustomizable {
    func searchRepository(for query: GithubSearchQueryCustomizable) -> AnyPublisher<GithubRepositoryResults, Error> {
        //TODO: return mock response
        return Empty().eraseToAnyPublisher()
    }
}
