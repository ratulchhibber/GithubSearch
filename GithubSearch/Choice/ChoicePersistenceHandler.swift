//
//  ChoicePersistenceHandler.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 19/10/21.
//

import Foundation

struct ChoicePersistenceHandler: ChoicePersistenceConfigurable {
           
    let userDefaults: UserDefaults

    let persistenceKey = "userChoice"

    func updateChoice(for githubId: GithubId, with choice: Choice) {
        var store = currentUserStore
        store[String(githubId)] = choice.rawValue
        userDefaults.set(store, forKey: persistenceKey)
    }
    
    func fetchChoice(for githubId: GithubId) -> Choice {
        guard
            let currentStore = userDefaults.dictionary(forKey: persistenceKey) as? [String: String],
            let choiceRawValue = currentStore[String(githubId)],
            let state = Choice(rawValue: choiceRawValue) else  {
                return .none
            }
        return state
    }
    
    private var currentUserStore: [String: String]/*[githubId: Choice]*/ {
        var store = [String: String]()
        if let currentStore = userDefaults.dictionary(forKey: persistenceKey) as? [String: String] {
            store = currentStore
        }
        return store
    }
}
