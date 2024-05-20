//
//  FlashCardRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum FlashCardRequests {
    // MARK: Groups
    
    static let group = NetworkConstants.baseGroup.subgroup(path: NetworkConstants.flashCardPath)
    
    static func deckGroup(deckID: Deck.ID) -> any GroupProtocol {
        DeckRequests
            .detailsGroup(for: deckID)
            .subgroup(path:  NetworkConstants.deckCardsPath)
    }
    
    static func deckDetailsGroup(deckID: Deck.ID, cardID: FlashCard.ID) -> any GroupProtocol {
        deckGroup(deckID: deckID).subgroup(path: "/\(cardID)")
    }
    
    static func cardDetailsGroup(cardID: FlashCard.ID) -> any GroupProtocol {
        group.subgroup(path: "/\(cardID)")
    }
    
    // MARK: Top Level
    static func add(to deckID: Deck.ID) -> AuthenticatedRequest<FlashCardDTO, FlashCardDTO, ErrorDTO> {
        deckGroup(deckID: deckID).request(path: "", method: .post)
    }
    
    static func list(for deckID: Deck.ID) -> PaginatedAuthRequest<FlashCardDTO> {
        deckGroup(deckID: deckID).request(path: "")
    }
    
    static func due(for deckID: Deck.ID) -> PaginatedAuthRequest<FlashCardDTO> {
        DeckRequests
            .detailsGroup(for: deckID)
            .subgroup(path: NetworkConstants.deckCardsDuePath)
            .request(path: "")
    }
    
    // MARK: Details
    static func update(in deckID: Deck.ID, cardID: FlashCard.ID) -> AuthenticatedRequest<FlashCardDTO, FlashCardDTO, ErrorDTO> {
        deckDetailsGroup(deckID: deckID, cardID: cardID).request(path: "", method: .put)
    }
    
    static func delete(from deckID: Deck.ID, cardID: FlashCard.ID)  -> AuthenticatedRequest<Nothing, Nothing?, ErrorDTO> {
        deckDetailsGroup(deckID: deckID, cardID: cardID).request(path: "", method: .delete)
    }
    
    // MARK: Practice
    static func updateReview(for cardID: FlashCard.ID) -> AuthenticatedRequest<FlashCardPracticeDTO, Nothing?, ErrorDTO> {
        cardDetailsGroup(cardID: cardID).request(path: NetworkConstants.updateReviewPath, method: .patch)
    }
}

