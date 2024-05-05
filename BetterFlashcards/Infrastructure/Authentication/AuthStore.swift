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
    
    func store(user: User, token: String) {
        KeychainWrapper.standard.set(
            token,
            forKey: KeychainKeys.token.rawValue
        )
        
        KeychainWrapper.standard.set(
            user.username,
            forKey: KeychainKeys.username.rawValue
        )
        
        KeychainWrapper.standard.set(
            user.id,
            forKey: KeychainKeys.userID.rawValue
        )
    }
}
