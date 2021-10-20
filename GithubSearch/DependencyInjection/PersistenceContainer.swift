//
//  PersistenceContainer.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 19/10/21.
//

import Foundation

extension DIContainer {
    struct Persistence {
        let choice: ChoicePersistenceConfigurable
        
        static var stub: Self {
            guard let defaults = UserDefaults(suiteName: "testSuite") else {
                fatalError("Could not initialize stub suite of UserDefaults")
            }
            return .init(choice: ChoicePersistenceHandler(userDefaults: defaults))
        }
    }
}
