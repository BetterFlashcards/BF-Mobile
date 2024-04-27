//
//  FlashCardRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum FlashCardRequests {
    static func group(deckID: Deck.ID) -> any GroupProtocol {
        DeckRequests
            .detailsGroup(for: deckID)
            .subgroup(path:  NetworkConstants.flashCardPath)
    }
    
    static func add(to deckID: Deck.ID) -> AuthenticatedRequest<CreateFlashCardDTO, FlashCard> {
        group(deckID: deckID).request(path: "/", method: .post)
    }
    
    static func list(for deckID: Deck.ID) -> AuthenticatedRequest<Nothing, [FlashCard]> {
        group(deckID: deckID).request(path: "/")
    }
}

