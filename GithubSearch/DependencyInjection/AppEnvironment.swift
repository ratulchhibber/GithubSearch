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
        let persistence = configuredPersistence()
        let diContainer = DIContainer(interactors: interactors, persistence: persistence)
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
    
    private static func configuredPersistence() -> DIContainer.Persistence {
        return .init(choice: ChoicePersistenceHandler(userDefaults: UserDefaults.standard))

    }
}

extension DIContainer {
    struct WebRepositories {
        let githubWebRepository: GithubSearchWebRepository
    }
}
