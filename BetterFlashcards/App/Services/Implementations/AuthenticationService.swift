//
//  AuthenticationService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

class AuthenticationService: AuthenticationServiceProtocol {
    private let auth: AuthenticationProtocol
    private let tokenProvider: TokenProviderProtocol
    
    private let eventSubject: CurrentValueSubject<AuthenticationServiceEvent, Never>
    
    var eventPublisher: AnyPublisher<AuthenticationServiceEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(auth: AuthenticationProtocol, tokenProvider: TokenProviderProtocol) {
        self.auth = auth
        self.tokenProvider = tokenProvider
        self.eventSubject = .init(AuthenticationServiceEvent(user: tokenProvider.user()))
    }
    
    func login(username: String, password: String) async throws -> User {
        let user = try await auth.login(username: username, password: password)
        eventSubject.send(.loggedIn(user))
        return user
    }
    
    func register(username: String, password: String) async throws -> User {
        let user = try await auth.register(username: username, password: password)
        eventSubject.send(.registered(user))
        return user
    }
    
    func logout() {
        tokenProvider.clearUserInfo()
        eventSubject.send(.loggedOut)
    }
    
}
