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
            type: AuthenticationServiceProtocol.self,
            eagerSingleton: MockAuthenticationService()
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
        let authStore = AuthStore()
        let authProvider = AuthProvider(authStore: authStore, client: apiClient)
        
        register(eagerSingleton: apiClient)
        register(type: AuthStoreProtocol.self, eagerSingleton: authStore)
        register(type: AuthProviderProtocol.self, eagerSingleton: authProvider)
        return self
    }
    
    private func withNetworkRepositories() -> Self {
        register(
            type: DeckRepositoryProtocol.self,
            lazySingleton: {
                DeckNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve()
                )
            }
        )
        
        register(
            type: FlashCardRepositoryProtocol.self,
            lazySingleton: {
                FlashCardNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve()
                )
            }
        )
        
        register(
            type: BookRepositoryProtocol.self,
            lazySingleton: {
                BookNetworkRepository(
                    client: $0.forceResolve(),
                    authStore: $0.forceResolve()
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
