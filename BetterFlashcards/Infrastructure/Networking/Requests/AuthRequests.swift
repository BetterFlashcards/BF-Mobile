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
    static func login() -> Request<UserDTO, LoginResponseDTO, ErrorDTO> {
        group.request(path: NetworkConstants.loginPath, method: .post)
    }
    
    static func refresh() -> Request<RefreshDTO, LoginResponseDTO, ErrorDTO> {
        group.request(path: NetworkConstants.refreshPath, method: .post)
    }
    
    static func verify() -> Request<VerifyDTO, Nothing, ErrorDTO> {
        group.request(path: NetworkConstants.verifyPath, method: .post)
    }
    
    static func register() -> Request<UserDTO, LoginResponseDTO, ErrorDTO> {
        NetworkConstants.baseGroup.request(path: NetworkConstants.registerPath, method: .post)
    }
}
