//
//  EnvironmentValues.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import SwiftUI
import DIContainer

private struct DIEnvironmentKey: EnvironmentKey {
    static let defaultValue: DIContainerProtocol = DIContainer().withDefaultDependencyGraph()
}

extension EnvironmentValues {
    var di: DIContainerProtocol {
        get { self[DIEnvironmentKey.self] }
        set { self[DIEnvironmentKey.self] = newValue }
    }
    
    var bookService: any BookServiceProtocol {
        self.di.forceResolve()
    }
    
    var deckService: any DeckServiceProtocol {
        self.di.forceResolve()
    }
    
    var flashcardService: any FlashCardServiceProtocol {
        self.di.forceResolve()
    }
    
    var auth: AuthenticationServiceProtocol {
        self.di.forceResolve()
    }
}
