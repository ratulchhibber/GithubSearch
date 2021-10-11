//
//  GithubRepositoryConfiguration.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Foundation

protocol WebRepositoryConfigurable {
    var session: URLSession { get }
    var baseURL: String { get }
}

final class GithubRepositoryConfiguration: WebRepositoryConfigurable {
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration)
    }
    
    var baseURL: String { "https://api.github.com" }
}
