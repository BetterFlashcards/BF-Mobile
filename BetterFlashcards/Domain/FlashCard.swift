//
//  FlashCard.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct FlashCard {
    let id: Int
    var frontWord: String
    var backWord: String
    var deckID: Deck.ID
    var isDraft: Bool
    var relatedBookID: Book.ID?
}

extension FlashCard: Identifiable, Codable {}
