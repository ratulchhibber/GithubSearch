//
//  AppEnvironment.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 11/10/21.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let webRepositories = configuredWebRepositories(for: GithubRepositoryConfiguration())
        let interactors = configuredInteractors(webRepositories: webRepositories)
        let diContainer = DIContainer(interactors: interactors)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredWebRepositories(for configuration: WebRepositoryConfigurable) -> DIContainer.WebRepositories {
        let githubWebRepository = GithubSearchWebRepository(session: configuration.session,
                                                            baseURL: configuration.baseURL)
        return .init(githubWebRepository: githubWebRepository)
    }
        
    private static func configuredInteractors(webRepositories: DIContainer.WebRepositories) -> DIContainer.Interactors {
        
        let githubRepositoryInteractor = GithubRepositoryInteractor(webRepository: webRepositories.githubWebRepository)
        return .init(githubRepositoryInteractor: githubRepositoryInteractor)
    }
}

extension DIContainer {
    struct WebRepositories {
        let githubWebRepository: GithubSearchWebRepository
    }
}
