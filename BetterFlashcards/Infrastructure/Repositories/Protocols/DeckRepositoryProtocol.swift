//
//  DeckRepositoryProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

protocol DeckRepositoryProtocol {
    func fetchAll() async throws -> [Deck]
    func fetch(at: Pagination) async throws -> PaginatedList<Deck>
    func fetch(by deckID: Deck.ID) async throws -> Deck?
    func create(deck: Deck) async throws -> Deck
    func update(deck: Deck) async throws -> Deck
    func delete(deck: Deck) async throws
}
