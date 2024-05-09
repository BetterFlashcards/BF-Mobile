//
//  AuthStore.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation

class AuthStore: AuthStoreProtocol {
    func user() -> User? {
        guard
            let username = KeychainWrapper.standard.string(forKey: KeychainKeys.username.rawValue)
        else {
            return nil
        }
        return User(username: username)
    }

    func token() throws -> String {
        guard
            let token = KeychainWrapper.standard.string(forKey: KeychainKeys.accessToken.rawValue)
        else {
            throw AuthError.tokenUnavailable
        }
        return token
    }
    
    func clearUserInfo() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.refreshToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKeys.username.rawValue)
    }
    
    func store(user: User, accessToken: String, refreshToken: String) {
        KeychainWrapper.standard.set(
            accessToken,
            forKey: KeychainKeys.accessToken.rawValue
        )
        
        KeychainWrapper.standard.set(
            refreshToken,
            forKey: KeychainKeys.refreshToken.rawValue
        )
        
        KeychainWrapper.standard.set(
            user.username,
            forKey: KeychainKeys.username.rawValue
        )
    }
}
