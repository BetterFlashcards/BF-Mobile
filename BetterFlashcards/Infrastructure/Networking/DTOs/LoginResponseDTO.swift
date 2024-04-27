//
//  LoginResponseDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct LoginResponseDTO: Codable {
    let userID: Int
    let username: String
    let token: String
}
