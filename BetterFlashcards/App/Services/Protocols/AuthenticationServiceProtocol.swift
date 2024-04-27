//
//  AuthenticationServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation
import Combine

protocol AuthenticationServiceProtocol {
    func login(username: String, password: String) async throws -> User
    func register(username: String, password: String) async throws -> User
    func logout() async

    var eventPublisher: AnyPublisher<AuthenticationServiceEvent, Never> { get }
}

enum AuthenticationServiceEvent {
    case loggedIn(User)
    case registered(User)
    case loggedOut
    
    init(user: User?) {
        if let user {
            self = .loggedIn(user)
        } else {
            self = .loggedOut
        }
    }
    
    var isLoggedIn: Bool {
        switch self {
        case .loggedOut:
            return false
        default:
            return true
        }
    }
}
