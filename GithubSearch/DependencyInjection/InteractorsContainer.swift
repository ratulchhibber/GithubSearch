//
//  InteractorsContainer.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

extension DIContainer {
    struct Interactors {
        let githubRepositoryInteractor: GithubRepositoryInteractorCustomizable
        
        init(githubRepositoryInteractor: GithubRepositoryInteractorCustomizable) {
            self.githubRepositoryInteractor = githubRepositoryInteractor
        }
        
        static var stub: Self {
            .init(githubRepositoryInteractor: StubGithubRepositoryInteractor())
        }
    }
}
