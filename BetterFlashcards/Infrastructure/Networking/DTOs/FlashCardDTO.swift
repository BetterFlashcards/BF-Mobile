//
//  FlashCardResponseDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation

struct FlashCardDTO: Codable {
    let id: FlashCard.ID
    let frontText: String
    let backText: String
    let deckID: Deck.ID
    let isDraft: Bool
    let relatedBookID: Book.ID?
    
    enum CodingKeys: String, CodingKey {
        case id
        case frontText = "front_text"
        case backText = "back_text"
        case deckID = "deck_id"
        case isDraft = "draft"
        case relatedBookID = "related_book"
    }
}
