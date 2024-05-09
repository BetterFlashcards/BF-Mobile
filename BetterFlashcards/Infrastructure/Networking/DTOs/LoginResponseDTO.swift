//
//  LoginResponseDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct LoginResponseDTO: Codable {
    let username: String?
    let refresh: String
    let access: String
}
