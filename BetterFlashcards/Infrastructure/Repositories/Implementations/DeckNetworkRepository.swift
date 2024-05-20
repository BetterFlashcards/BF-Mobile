//
//  DeckNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class DeckNetworkRepository: BaseAuthenticatedNetworking, DeckRepositoryProtocol {
    let deckRequests = DeckRequests.self
    
    func fetch(at pagination: Pagination) async throws -> PaginatedList<Deck> {
        let response = try await client.make(request: deckRequests.list(), headers: try await headers(), queries: PaginationQueryDTO(pagination: pagination)).data
        return .init(items: response.items, count: response.count, pagination: pagination)
    }
    
    func fetch(by deckID: Deck.ID) async throws -> Deck? {
        try await client.make(request: deckRequests.details(for: deckID), headers: try await headers()).data
    }
    
    func create(deck: Deck) async throws -> Deck {
        let dto = CreateDeckDTO(name: deck.name, language: deck.language ?? "")
        _ = try await client.make(request: deckRequests.create(), body: dto, headers: try await headers()).data
        return deck
    }
    
    func update(deck: Deck) async throws -> Deck {
        try await client.make(request: deckRequests.update(at: deck.id), body: deck, headers: try await headers()).data
    }
    
    func delete(deck: Deck) async throws {
        _ = try await client.make(request: deckRequests.delete(at: deck.id), headers: try await headers())
    }
}
