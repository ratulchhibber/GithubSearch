//
//  RepositorySearchVM.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation
import Combine

final class RepositorySearchVM: ObservableObject {
    
    @Published var searchText = ""
    @Published var searchResults: Loadable<GithubRepositoryResults>
    @Published var loadMore: Loadable<Bool>
    
    @Published var selectedRepository: GithubRepositoryResult?
    @Published var userChoice = [Int: Choice]()/*RepositoryId: Choice*/

    private var subscriptions = Set<AnyCancellable>()
    
    let container: DIContainer
    
    init(container: DIContainer,
         searchResults: Loadable<GithubRepositoryResults> = .notRequested,
         loadMore: Loadable<Bool> = .notRequested) {
        
        _searchResults = .init(initialValue: searchResults)
        _loadMore = .init(initialValue: loadMore)
        self.container = container
        setupContinousSearchBinding()
        setupClearSearchBinding()
    }
    
    //Pagination
    private var pagination: (currentPage: Int,
                             results: GithubRepositoryResults?) = (0, nil)
}

extension RepositorySearchVM {
    
    private func setupContinousSearchBinding() {
        $searchText
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .compactMap { [weak self] query in
                self?.container.interactors
                    .githubRepositoryInteractor
                    .searchRepository(for: SearchQuery(query: query, pageNumber: 1))

                    .handleEvents(receiveRequest: { [weak self] _ in
                        self?.searchResults
                             .setIsLoading(cancelBag: CancelBag())
                    })
                    .catch { error -> AnyPublisher<GithubRepositoryResults, Never> in
                        if let placeholder = self?.searchErrorPlaceHolder {
                            return Just(placeholder).eraseToAnyPublisher()
                        }
                        return Empty().eraseToAnyPublisher()
                    }
            }
            .switchToLatest()
            .sink(receiveValue: { [weak self] in
                    self?.pagination.currentPage = 0
                    self?.updatePaginationAnchors(for: $0)
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
    
    private var searchErrorPlaceHolder: GithubRepositoryResults? {
        return Bundle.main.decode(GithubRepositoryResults.self,
                                  from: "searchErrorPlaceholder.json",
                                  keyDecodingStrategy: .convertFromSnakeCase)
    }
    
    func hasErroneousResults(for result: GithubRepositoryResults) -> Bool {
        return result.totalCount == -1
    }
    
    func hasNoResults(for result: GithubRepositoryResults) -> Bool {
        return result.items.isEmpty
    }
}

// MARK: - Pagination
extension RepositorySearchVM {
    
    func loadMoreResults() {
        container.interactors
            .githubRepositoryInteractor
            .searchRepository(for: SearchQuery(query: searchText,
                                               pageNumber: pagination.currentPage + 1))
            .handleEvents(receiveRequest: { [weak self] _ in
                self?.loadMore
                     .setIsLoading(cancelBag: CancelBag())
            })
            .sink { [weak self] result in
                switch result {
                    case .failure(let error):
                        self?.loadMore = .failed(error)
                    case .finished:
                        break
                }
            } receiveValue: { [weak self] result in
                if let pagination = self?.pagination, var results = pagination.results {
                    results.items.append(contentsOf: result.items)
                    self?.updatePaginationAnchors(for: results)
                    self?.searchResults = .loaded(results)
                }
            }
            .store(in: &subscriptions)
    }
    
    private func updatePaginationAnchors(for results: GithubRepositoryResults) {
        pagination.currentPage += 1
        pagination.results = results
        loadMore = .loaded(results.totalCount > results.items.count)
    }
}

// MARK: - User choice
enum Choice: CustomStringConvertible {
    case like, dislike, none
    
    var description: String {
        switch self {
            case .like: return "👍"
            case .dislike: return "👎"
            case .none: return ""
        }
    }
}

extension RepositorySearchVM {
    
    func choiceDescription(for id: Int) -> String {
        if let choice = userChoice[id] {
            return choice.description
        }
        return Choice.none.description
    }
}
