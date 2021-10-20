//
//  GithubSearchApp.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import SwiftUI

@main
struct GithubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            let environment = AppEnvironment.bootstrap()
            RepositorySearchView(viewModel:
                                    RepositorySearchVM(container: environment.container))
        }
    }
}
