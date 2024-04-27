//
//  Deck.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct Deck {
    let id: Int
    var name: String
    var language: String?
}

extension Deck: Identifiable, Codable, Hashable {}
