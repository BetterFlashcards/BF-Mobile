//
//  AuthenticationService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

protocol AuthProviderProtocol {
    func login(username: String, password: String) async throws -> User
    func register(username: String, password: String) async throws -> User
}

protocol AuthStoreProtocol {
    func token() throws -> String
    func user() -> User?
    func clearUserInfo()
    func store(user: User, accessToken: String, refreshToken: String)
}
