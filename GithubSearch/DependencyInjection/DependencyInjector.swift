//
//  DIContainer.swift
//  GithubSearch
//
//  Created by Ratul Chhibber on 09/10/21.
//

import SwiftUI
import Combine

// MARK: - DIContainer

struct DIContainer {
    
    let interactors: Interactors
    let persistence: Persistence

    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(interactors: .stub,
                                        persistence: .stub)

}

