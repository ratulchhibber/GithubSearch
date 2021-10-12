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
        return Just(Bundle.main
                        .decode(GithubRepositoryResults.self,
                                from: "searchResults.json",
                                keyDecodingStrategy: .convertFromSnakeCase)
                    ).mapError({ _ in  APIError.unexpectedResponse })
                     .eraseToAnyPublisher()
    }
}
