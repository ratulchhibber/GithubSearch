//
//  RepositorySearchVM.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation
import Combine

class RepositorySearchVM: ObservableObject {
    
    @Published var searchText = ""
    @Published var searchResults: Loadable<GithubRepositoryResults>
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchResults: Loadable<GithubRepositoryResults> = .notRequested) {
        _searchResults = .init(initialValue: searchResults)
        setupContinousSearchBinding()
        setupClearSearchBinding()lc
    }
}

extension RepositorySearchVM {
    
    private func setupContinousSearchBinding() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .compactMap { query in
                RepositoryFactory
                    .githubSearchRepository(for: GithubRepositoryConfiguration())
                    .searchRepository(for: SearchQuery(query: query, pageNumber: 1))

                    .handleEvents(receiveRequest: { [weak self] _ in
                        self?.searchResults
                             .setIsLoading(cancelBag: CancelBag())
                    })
                    .catch { error -> AnyPublisher<GithubRepositoryResults, Never> in
                        return Empty().eraseToAnyPublisher()
                    }
            }
            .switchToLatest()
            .sink(receiveValue: { [weak self] in
                    self?.searchResults = .loaded($0)
                  })
            .store(in: &subscriptions)
    }
    
    private func setupClearSearchBinding() {
        $searchText
            .filter { $0.isEmpty }
            .sink(receiveValue: { [weak self] _ in
                self?.searchResults = .notRequested
            })
            .store(in: &subscriptions)
    }
    
    private struct SearchQuery: GithubSearchQueryCustomizable {
        var query: String
        var pageNumber: Int
        var perPageResults = 10
    }
}
