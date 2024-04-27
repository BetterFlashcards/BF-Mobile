//
//  Auth.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class AuthProvider: BaseNetworking, AuthenticationProtocol, TokenProviderProtocol {
    let authRequests = AuthRequests.self

    func login(username: String, password: String) async throws -> User {
        let result = await client.make(request: authRequests.login(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        store(login)
        return User(id: login.userID, username: login.username)
    }
    
    func register(username: String, password: String) async throws -> User {
        let result = await client.make(request: authRequests.register(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        store(login)
        return User(id: login.userID, username: login.username)
    }

    func user() -> User? {
        guard
            let username = KeychainWrapper.standard.string(forKey: KeychainKeys.username.rawValue),
            let userID = KeychainWrapper.standard.integer(forKey: KeychainKeys.userID.rawValue)
        else {
            return nil
        }
        return User(id: userID, username: username)
    }

    func token() throws -> String {
        guard
            let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token.rawValue)
        else {
            throw AuthError.tokenUnavailable
        }
        return token
    }
    
    func clearUserInfo() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.token.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.username.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.userID.rawValue)
    }
    
    private func store(_ login: LoginResponseDTO) {
        KeychainWrapper.standard.set(
            login.token,
            forKey: KeychainKeys.token.rawValue
        )
        
        KeychainWrapper.standard.set(
            login.username,
            forKey: KeychainKeys.username.rawValue
        )
        
        KeychainWrapper.standard.set(
            login.userID,
            forKey: KeychainKeys.userID.rawValue
        )
    }
}
