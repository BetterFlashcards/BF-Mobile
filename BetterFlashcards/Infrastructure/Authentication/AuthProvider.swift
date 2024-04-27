//
//  Auth.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class AuthProvider: BaseNetworking, AuthenticationProtocol, TokenProviderProtocol {
    let authRequests = AuthRequests.self

    func login(username: String, password: String) async throws {
        let result = await client.make(request: authRequests.login(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        store(login)
    }
    
    func register(username: String, password: String) async throws {
        let result = await client.make(request: authRequests.register(), body: UserDTO(username: username, password: password))
        let login = try convertResult(result: result)
        store(login)
    }

    func token() async throws -> String {
        guard
            let token = KeychainWrapper.standard.string(forKey: KeychainKeys.token.rawValue)
        else {
            throw AuthError.tokenUnavailable
        }
        return token
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
