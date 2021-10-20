//
//  ChoicePersistenceConfigurable.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 20/10/21.
//

import Foundation

protocol ChoicePersistenceConfigurable {
    var userDefaults: UserDefaults { get }
    var persistenceKey: String { get }
    func updateChoice(for githubId: GithubId, with choice: Choice)
    func fetchChoice(for githubId: GithubId) -> Choice
}

// MARK: - User choice
enum Choice: String, CustomStringConvertible {
    case like, dislike, none
    
    var description: String {
        switch self {
            case .like: return "👍"
            case .dislike: return "👎"
            case .none: return ""
        }
    }
}
