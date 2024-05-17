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
    func refresh(token: String) async throws -> String
    func verify(token: String) async throws -> Bool
}

protocol AuthStoreProtocol {
    func token() throws -> String
    func refresh() throws -> String
    func user() -> User?
    func clearUserInfo()
    func store(user: User)
    func store(accessToken: String, refreshToken: String)
}
