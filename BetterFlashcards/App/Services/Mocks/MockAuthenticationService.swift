//
//  MockAuthenticationService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

actor MockAuthenticationService: AuthenticationServiceProtocol {
    private var user: User?
    private let eventSubject: CurrentValueSubject<AuthenticationServiceEvent, Never>
    private let authStore: AuthStoreProtocol
    
    nonisolated var eventPublisher: AnyPublisher<AuthenticationServiceEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(user: User? = nil, authStore: AuthStoreProtocol) {
        self.user = user
        self.authStore = authStore
        self.eventSubject = .init(AuthenticationServiceEvent(user: user))
    }
    
    func login(username: String, password: String) async throws -> User {
        let user = User(id: 1, username: username)
        self.user = user
        authStore.store(user: user, token: "token")
        eventSubject.send(.loggedIn(user))
        return user
    }
    
    func register(username: String, password: String) async throws -> User {
        let user = User(id: 2, username: username)
        self.user = user
        authStore.store(user: user, token: "token")
        eventSubject.send(.registered(user))
        return user
    }
    
    func logout() {
        user = nil
        authStore.clearUserInfo()
        eventSubject.send(.loggedOut)
    }
}
