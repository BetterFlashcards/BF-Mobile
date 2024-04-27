//
//  AuthenticationService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

protocol AuthenticationProtocol {
    func login(username: String, password: String) async throws
    func register(username: String, password: String) async throws
}

protocol TokenProviderProtocol {
    func token() async throws -> String
}
