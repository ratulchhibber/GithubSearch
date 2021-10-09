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
                Text("Searching for \(viewModel.searchText)")
                    .searchable(text: $viewModel.searchText)
                    .disableAutocorrection(true)
                    .navigationTitle("Github Search")
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RepositorySearchView()
    }
}
