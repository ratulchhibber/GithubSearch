//
//  GithubSearchTests.swift
//  GithubSearchTests
//
//  Created by Ratul Chhibber on 09/10/21.
//

import XCTest
import Combine
@testable import GithubSearch

final class GithubSearchTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: RepositorySearchVM!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let diContainer = DIContainer(interactors: DIContainer.Interactors.stub,
                                      persistence: DIContainer.Persistence.stub)
        viewModel = RepositorySearchVM(container: diContainer)
    }
    
    func testSearchResultsModel() {
        var testResultCount = 0
        let promise = expectation(description: "searchResultsLoaded with 14 results")
        viewModel.container
            .interactors
            .githubRepositoryInteractor
            .searchRepository(for: SearchQuery(query: "testQuery",
                                               pageNumber: 1,
                                               perPageResults: 14))
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
            } receiveValue: { result in
                testResultCount = result.totalCount
                promise.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertEqual(testResultCount, 14)
    }
    
    func testHasLoadMoreResults() {
        
        var hasLoadMore = false
        let searchQuery = SearchQuery(query: "testQuery",
                                      pageNumber: 1,
                                      perPageResults: 12)
        
        let promise = expectation(description: "searchResultsLoaded with 12 results")
        viewModel.container
            .interactors
            .githubRepositoryInteractor
            .searchRepository(for: searchQuery)
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        XCTFail()
                }
            } receiveValue: { result in
                hasLoadMore = result.totalCount > searchQuery.perPageResults
                promise.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [promise], timeout: 1)
        
        XCTAssertTrue(hasLoadMore)

    }
    
    func testLikeChoice() {
        viewModel.userChoice = (1234, .like)

        let exp = expectValue(of: viewModel.$userChoice,
                              equals: [{ $0.choice == .like }])

        wait(for: [exp.expectation], timeout: 1)
    }
    
    func testDislikedChoice() {
        viewModel.userChoice = (1234, .dislike)
        
        let exp = expectValue(of: viewModel.$userChoice,
                              equals: [{ $0.choice == .dislike }])

        wait(for: [exp.expectation], timeout: 1)
    }
    
    func testNoChoice() {
        viewModel.userChoice = (1234, .none)

        let exp = expectValue(of: viewModel.$userChoice,
                              equals: [{ $0.choice == .none }])

        wait(for: [exp.expectation], timeout: 1)
    }
    
    func testLikedChoiceDescription() {
        viewModel.userChoice = (1234, .like)
        XCTAssertEqual(viewModel.choiceDescription(for: 1234), Choice.like.description)
    }
    
    func testDislikedChoiceDescription() {
        viewModel.userChoice = (1234, .dislike)
        XCTAssertEqual(viewModel.choiceDescription(for: 1234), Choice.dislike.description)
    }
    
    func testNoneChoiceDescription() {
        XCTAssertEqual(viewModel.choiceDescription(for: 1234), Choice.none.description)
    }
}

private struct SearchQuery: GithubSearchQueryCustomizable {
    var query: String
    var pageNumber: Int
    var perPageResults: Int
}
