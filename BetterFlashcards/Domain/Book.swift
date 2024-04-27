//
//  Book.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct Book {
    let id: Int
    var title: String
    var author: String
}

extension Book: Identifiable, Codable {}
