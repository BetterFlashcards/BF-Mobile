//
//  DI.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import DIContainer
import APIClient

extension DIContainerProtocol {
    func withDefaultDependencyGraph() -> Self {
        return self
            .withDefaultUtilities()
            .withDefaultAuth()
            .withNetworkRepositories()
            .withDefaultServices()
    }
    
    func withMockServices() -> Self {
        register(
            type: (any DeckServiceProtocol).self,
            eagerSingleton: MockDeckService()
        )
        
        register(
            type: FlashCardServiceProtocol.self,
            eagerSingleton: MockFlashCardService()
        )
        
        register(
            type: (any BookServiceProtocol).self,
            eagerSingleton: MockBookService()
        )
        
        register(
            type: LanguageServiceProtocol.self,
            eagerSingleton: MockLanguageService()
        )
        
        register(
            type: AuthenticationServiceProtocol.self,
            lazySingleton: { MockAuthenticationService(authStore: AuthStore()) }
        )
        return self
    }
    
    private func withDefaultUtilities() -> Self {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        
        let apiClient = APIClient(
            encoder: encoder,
            decoder: decoder
        )
        register(type: Client.self, eagerSingleton: apiClient)
        return self
    }
    
    private func withDefaultAuth() -> Self {
        let authStore = AuthStore()
        
        register(type: AuthStoreProtocol.self, eagerSingleton: authStore)
        register(
            type: AuthProviderProtocol.self,
            lazySingleton: {
                AuthProvider(authStore: $0.forceResolve(), client: $0.forceResolve())
            }
        )
        return self
    }
    
    private func withNetworkRepositories() -> Self {
        register(
            type: DeckRepositoryProtocol.self,
            lazySingleton: {
                DeckNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve(),
                    authProvider: $0.forceResolve()
                )
            }
        )
        
        register(
            type: FlashCardRepositoryProtocol.self,
            lazySingleton: {
                FlashCardNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve(),
                    authProvider: $0.forceResolve()
                )
            }
        )
        
        register(
            type: BookRepositoryProtocol.self,
            lazySingleton: {
                BookNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve(),
                    authProvider: $0.forceResolve()
                )
            }
        )
        
        register(
            type: LanguageRepositoryProtocol.self,
            lazySingleton: {
                LanguageNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve(),
                    authProvider: $0.forceResolve()
                )
            }
        )
        
        return self
    }
    
    private func withDefaultServices() -> Self {
        register(
            type: (any DeckServiceProtocol).self,
            lazySingleton: {
                DeckService(deckRepo: $0.forceResolve())
            }
        )
        
        register(
            type: FlashCardServiceProtocol.self,
            lazySingleton: {
                FlashCardService(flashCardRepo: $0.forceResolve())
            }
        )
        
        register(
            type: (any BookServiceProtocol).self,
            lazySingleton: {
                BookService(bookRepo: $0.forceResolve())
            }
        )
        
        register(
            type: LanguageServiceProtocol.self,
            lazySingleton: {
                LanguageService(languageRepo: $0.forceResolve())
            }
        )
        
        register(
            type: AuthenticationServiceProtocol.self,
            lazySingleton: {
                AuthenticationService(
                    authProvider: $0.forceResolve(),
                    authStore: $0.forceResolve()
                )
            }
        )
        
        return self
    }
}
