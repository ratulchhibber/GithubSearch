//
//  RepositorySearchView.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import SwiftUI

struct RepositorySearchView: View {
    
    @StateObject private var viewModel = RepositorySearchVM()
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
            case .loaded(let results): loadedView(for: results.items)
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
    private func loadedView(for items: [GithubRepositoryResult]) -> some View {
        if items.isEmpty {
            Text("No results found")
        } else {
            List {
                ForEach(items) { item in
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
                    RepositoryDetailView(repository: selection)
                }
            }
        }
    }
    
    @ViewBuilder
    private func errorView() -> some View {
        Text("Oops, Something went wrong!")
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
            Text("⭐️ \(item.stargazersCount)")
        }
        .contentShape(Rectangle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchView()
    }
}
