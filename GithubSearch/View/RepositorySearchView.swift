//
//  RepositorySearchView.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import SwiftUI

struct RepositorySearchView: View {
    @StateObject private var viewModel = RepositorySearchVM()
    
    var body: some View {
        NavigationView {
            contentView()
                .searchable(text: $viewModel.searchText)
                .disableAutocorrection(true)
                .navigationTitle("Github Search")
        }
    }
}

extension RepositorySearchView {
    
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.searchResults {
            case .notRequested: notRequestedView()
            case .isLoading: loadingView()
            case .loaded(let results): loadedView(for: results.items)
            case .failed: errorView()
        }
    }
    
    @ViewBuilder
    private func notRequestedView() -> some View {
        Text("Search not requested")
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        Text("Loading...")
    }
    
    @ViewBuilder
    private func loadedView(for items: [GithubRepositoryResult]) -> some View {
        if items.isEmpty {
            Text("No results found")
        } else {
            List(items) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.name)
                            .font(.title2)
                        Text(item.language ?? "")
                            .font(.body)
                    }
                    Spacer()
                    Text("⭐️ \(item.stargazers_count)")
                }
            }
        }
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        Text("Oops, Something went wrong!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchView()
    }
}
