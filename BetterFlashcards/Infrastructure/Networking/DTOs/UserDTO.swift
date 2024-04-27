//
//  UserDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

struct UserDTO {
    let username: String
    let password: String
}

extension UserDTO: Codable {}
