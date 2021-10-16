//
//  RepositorySearchView.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import SwiftUI

struct RepositorySearchView: View {
    
    @ObservedObject private(set) var viewModel: RepositorySearchVM
    @State private var showModal = false

    var body: some View {
        NavigationView {
            contentView()
                .navigationTitle("Github Search")
        }
        .searchable(text: $viewModel.searchText)
        .disableAutocorrection(true)
    }
}

extension RepositorySearchView {
        
    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.searchResults {
            case .notRequested: notRequestedView()
            case .isLoading: loadingView(for: .large)
            case .loaded(let results): loadedView(for: results)
            case .failed: errorView()
        }
    }
    
    @ViewBuilder
    private func notRequestedView() -> some View {
        Text("Search not requested")
    }
    
    @ViewBuilder
    private func loadingView(for style: UIActivityIndicatorView.Style) -> some View {
        ActivityIndicatorView(style: style)
            .padding()
    }
    
    @ViewBuilder
    private func loadedView(for results: GithubRepositoryResults) -> some View {
        if viewModel.hasErroneousResults(for: results) {
            errorView()
        } else if viewModel.hasNoResults(for: results) {
            noResultsView()
        } else {
            resultsView(for: results)
        }
    }
    
    @ViewBuilder
    private func noResultsView() -> some View {
        Text("No results found")
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        Text("Oops, Something went wrong!")
    }
    
    @ViewBuilder
    private func resultsView(for results: GithubRepositoryResults) -> some View {
        List {
            ForEach(results.items, id: \.id) { item in
                repositoryRow(for: item)
                    .onTapGesture {
                        viewModel.selectedRepository = item
                        showModal.toggle()
                    }
            }
            
            if viewModel.hasMoreResults {
                loadingView(for: .medium)
                    .onAppear {
                        viewModel.loadMore()
                    }
            }
        }.sheet(isPresented: $showModal) {
            if let selection = viewModel.selectedRepository {
                RepositoryDetailView(userChoice: $viewModel.userChoice,
                                     repository: selection)
            }
        }

    }
    
    @ViewBuilder
    private func repositoryRow(for item: GithubRepositoryResult) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(item.name)
                    .font(.title2)
                Text(item.language ?? "")
                    .font(.body)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 10) {
                Text("⭐️ \(item.stargazersCount)")
                Text(viewModel.choiceDescription(for: item.githubId))
            }
        }
        .contentShape(Rectangle())
    }
}
