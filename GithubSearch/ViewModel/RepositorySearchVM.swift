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
    @Published var hasMoreResults = false
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchResults: Loadable<GithubRepositoryResults> = .notRequested) {
        _searchResults = .init(initialValue: searchResults)
        setupContinousSearchBinding()
        setupClearSearchBinding()
    }
    
    //Pagination
    private var paginationSearchResults: GithubRepositoryResults?
    private var pagination: (currentPage: Int,
                             results: GithubRepositoryResults?) = (0, nil)
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
                    self?.pagination.currentPage = 0
                    self?.setupPaginationAnchors(for: $0)
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
        var perPageResults = 12
    }
}

extension RepositorySearchVM {
    
    func loadMore() {
        RepositoryFactory
            .githubSearchRepository(for: GithubRepositoryConfiguration())
            .searchRepository(for: SearchQuery(query: searchText,
                                               pageNumber: pagination.currentPage + 1))
            .sink { [weak self] result in
                switch result {
                    case .failure(_):
                        if let results = self?.pagination.results {
                            self?.hasMoreResults = false
                            //Currently, not notifying the user that loadMore failed
                            self?.searchResults = .loaded(results)
                        }
                    case .finished:
                        break
                }
            } receiveValue: { [weak self] result in
                if let pagination = self?.pagination, var results = pagination.results {
                    results.items.append(contentsOf: result.items)
                    self?.setupPaginationAnchors(for: results)
                    self?.searchResults = .loaded(results)
                }
                
            }
            .store(in: &subscriptions)
    }
    
    private func setupPaginationAnchors(for results: GithubRepositoryResults) {
        pagination.currentPage += 1
        pagination.results = results
        hasMoreResults = results.totalCount > (pagination.results?.items.count ?? 0)
    }
}
