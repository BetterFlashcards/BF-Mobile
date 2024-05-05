//
//  FlashCardResponseDTO.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 05/05/2024.
//

import Foundation

struct FlashCardResponseDTO: Codable {
    let id: FlashCard.ID
    let frontText: String
    let backText: String
    let deck: Deck
    
    enum CodingKeys: String, CodingKey {
        case id
        case frontText = "front_text"
        case backText = "back_text"
        case deck
    }
}
