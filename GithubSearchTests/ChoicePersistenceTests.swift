//
//  ChoicePersistenceTests.swift
//  GithubSearchTests
//
//  Created by Ratul Chhibber on 20/10/21.
//

import XCTest
import Combine
@testable import GithubSearch

final class ChoicePersistenceTests: XCTestCase {
    
    private var viewModel: RepositorySearchVM!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let diContainer = DIContainer(interactors: DIContainer.Interactors.stub,
                                      persistence: DIContainer.Persistence.stub)
        viewModel = RepositorySearchVM(container: diContainer)
    }
    
    override func tearDownWithError() throws {
        choicePersistence
                 .userDefaults
                 .removePersistentDomain(forName: "testSuite")
        try super.tearDownWithError()
    }
    
    private var choicePersistence: ChoicePersistenceConfigurable {
        viewModel.container.persistence.choice
    }
    
    func testLikedChoicePersistence() {
        choicePersistence.updateChoice(for: 1234, with: .like)
        
        XCTAssert(choicePersistence
                    .fetchChoice(for: 1234) == .like, "Unexpected choice in PersistentStore")
    }
    
    func testDislikedChoicePersistence() {
        choicePersistence.updateChoice(for: 1234, with: .dislike)
        
        XCTAssert(choicePersistence
                    .fetchChoice(for: 1234) == .dislike, "Unexpected choice in PersistentStore")
    }
    
    func testNoChoicePersistence() {
        XCTAssert(choicePersistence
                    .fetchChoice(for: 1234) == .none, "Unexpected choice in PersistentStore")
    }
}

