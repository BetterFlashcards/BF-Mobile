//
//  Auth.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

actor AuthProvider: BaseNetworkingProtocol, AuthProviderProtocol {
    let client: Client
    let authRequests = AuthRequests.self
    let authStore: AuthStoreProtocol
    
    init(authStore: AuthStoreProtocol, client: Client) {
        self.authStore = authStore
        self.client = client
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
    
    func verify(token: String) async throws -> Bool {
        let result = await client.make(request: authRequests.verify(), body: VerifyDTO(token: token))
        switch result {
        case .success(let response):
            if let meta = response.meta {
                return meta.statusCode >= 200 && meta.statusCode < 400
            } else {
                return false
            }
        case .failure(let error):
            throw error
        }
    }
    
    func refresh(token: String) async throws -> String {
        let result = await client.make(request: authRequests.refresh(), body: RefreshDTO(refresh: token))
        let response = try convertResult(result: result)
        authStore.store(accessToken: response.access, refreshToken: response.refresh)
        return response.access
    }
}
