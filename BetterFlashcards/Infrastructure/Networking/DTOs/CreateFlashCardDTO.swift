//
//  CreateFlashCardDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

struct CreateFlashCardDTO: Codable {
    var frontWord: String
    var backWord: String
    var isDraft: Bool
    var deckID: Deck.ID
    var relatedBookID: Book.ID?
}
