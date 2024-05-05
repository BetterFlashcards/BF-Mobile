//
//  DeckRequests.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import APIClient

enum DeckRequests {
    static let group = NetworkConstants.baseGroup.subgroup(path: NetworkConstants.deckPath)
    
    // MARK: Subgroups
    static func detailsGroup(for deckID: Deck.ID) -> any GroupProtocol {
        return group.subgroup(path: "/\(deckID)")
    }
    
    // MARK: Top Level
    static func list() -> AuthenticatedRequest<Nothing, [Deck]> {
        group.request(path: "/")
    }
    
    static func create() -> AuthenticatedRequest<CreateDeckDTO, Deck> {
        group.request(path: "/", method: .post)
    }
    
    // MARK: Details
    static func details(for deckID: Deck.ID) -> AuthenticatedRequest<Nothing, Deck> {
        detailsGroup(for: deckID).request(path: "/")
    }

    static func update(at deckID: Deck.ID) -> AuthenticatedRequest<Deck, Deck> {
        detailsGroup(for: deckID).request(path: "/", method: .put)
    }
    
    static func delete(at deckID: Deck.ID) -> AuthenticatedRequest<Nothing, Nothing?> {
        detailsGroup(for: deckID).request(path: "/", method: .delete)
    }
}
