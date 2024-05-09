//
//  Auth.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

class AuthProvider: BaseNetworking, AuthProviderProtocol {
    let authRequests = AuthRequests.self
    let authStore: AuthStoreProtocol
    
    init(authStore: AuthStoreProtocol, client: Client) {
        self.authStore = authStore
        super.init(client: client)
    }

    func login(username: String, password: String) async throws -> User {
        let result = await client.make(request: authRequests.login(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        let user = User(username: login.username ?? username)
        authStore.store(user: user)
        authStore.store(accessToken: login.access, refreshToken: login.refresh)
        return user
    }
    
    func register(username: String, password: String) async throws -> User {
        let result = await client.make(request: authRequests.register(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        let user = User(username: login.username ?? username)
        authStore.store(user: user)
        authStore.store(accessToken: login.access, refreshToken: login.refresh)
        return user
    }
}
