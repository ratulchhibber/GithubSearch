//
//  GithubSearchWebRepository.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import Combine
import Foundation

protocol GithubSearchWebRepositoryConfigurable: WebRepository {
    func searchRepository(for query: GithubSearchQueryCustomizable) -> AnyPublisher<GithubRepositoryResults, Error>
}

protocol GithubSearchQueryCustomizable {
    var query: String { get }
    var perPageResults: Int { get }
    var pageNumber: Int { get }
}

struct GithubSearchWebRepository: GithubSearchWebRepositoryConfigurable {
    
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func searchRepository(for query: GithubSearchQueryCustomizable) -> AnyPublisher<GithubRepositoryResults, Error> {
        return call(endpoint: API.searchRepository(query: query))
    }
}

// MARK: - Endpoints
extension GithubSearchWebRepository {
    enum API {
        case searchRepository(query: GithubSearchQueryCustomizable)
    }
}

extension GithubSearchWebRepository.API: APICall {
    var path: String {
        switch self {
            case .searchRepository(let params):
                var components = URLComponents()
                components.path = "/search/repositories"
                components.queryItems = [
                                            URLQueryItem(name: "q", value: params.query),
                                            URLQueryItem(name: "per_page", value: "\(params.perPageResults)"),
                                            URLQueryItem(name: "page", value: "\(params.pageNumber)")
                                        ]
                return components.url?.absoluteString ?? ""
        }
    }
    
    var method: String {
        switch self {
        case .searchRepository:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}

