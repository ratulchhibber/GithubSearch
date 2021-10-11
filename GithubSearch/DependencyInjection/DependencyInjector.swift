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
    
    init(interactors: Interactors) {
        self.interactors = interactors
    }
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = Self(interactors: .stub)
}

