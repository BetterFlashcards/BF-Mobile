//
//  User.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

struct User {
    let username: String
}

extension User: Identifiable {
    var id: String { username }
}
