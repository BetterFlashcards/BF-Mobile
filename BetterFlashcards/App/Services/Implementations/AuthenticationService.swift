//
//  AuthenticationService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

class AuthenticationService: AuthenticationServiceProtocol {
    private let authProvider: AuthProviderProtocol
    private let authStore: AuthStoreProtocol
    
    private let eventSubject: CurrentValueSubject<AuthenticationServiceEvent, Never>
    
    var eventPublisher: AnyPublisher<AuthenticationServiceEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(authProvider: AuthProviderProtocol, authStore: AuthStoreProtocol) {
        self.authProvider = authProvider
        self.authStore = authStore
        self.eventSubject = .init(AuthenticationServiceEvent(user: authStore.user()))
    }
    
    func login(username: String, password: String) async throws -> User {
        let user = try await authProvider.login(username: username, password: password)
        eventSubject.send(.loggedIn(user))
        return user
    }
    
    func register(username: String, password: String) async throws -> User {
        let user = try await authProvider.register(username: username, password: password)
        eventSubject.send(.registered(user))
        return user
    }
    
    func logout() {
        authStore.clearUserInfo()
        eventSubject.send(.loggedOut)
    }
    
}
