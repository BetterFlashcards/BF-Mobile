//
//  AuthRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum AuthRequests {
    static let group = NetworkConstants.baseGroup.subgroup(path: NetworkConstants.authPath)
    
    // MARK: Top Level
    static func login() -> Request<UserDTO, LoginResponseDTO> {
        group.request(path: NetworkConstants.loginPath)
    }
    
    static func register() -> Request<UserDTO, LoginResponseDTO> {
        group.request(path: NetworkConstants.loginPath)
    }
}
