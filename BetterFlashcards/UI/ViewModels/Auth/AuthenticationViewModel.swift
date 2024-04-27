//
//  LoginViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var isLoggedIn: Bool
    @Published var type: AuthType
    @Published var errorMessage: String?
    
    init(username: String = "", password: String = "") {
        self.username = username
        self.password = password
        self.type = .register
        self.isLoggedIn = false
        self.errorMessage = nil
    }
    
    enum AuthType {
        case login
        case register
        
        mutating func toggle() {
            switch self {
            case .register:
                self = .login
            case .login:
                self = .register
            }
        }
    }
}
