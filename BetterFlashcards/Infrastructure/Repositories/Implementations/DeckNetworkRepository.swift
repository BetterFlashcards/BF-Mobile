//
//  DeckNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

class DeckNetworkRepository: BaseAuthenticatedNetworking, DeckRepositoryProtocol {
    let deckRequests = DeckRequests.self
    
    func fetchAll() async throws -> [Deck] {
        let result = await client.make(request: deckRequests.list(), headers: try await headers())
        return try convertResult(result: result).items
    }
    
    func fetch(by deckID: Deck.ID) async throws -> Deck? {
        let result = await client.make(request: deckRequests.details(for: deckID), headers: try await headers())
        return try convertResult(result: result)
    }
    
    func create(deck: Deck) async throws -> Deck {
        let dto = CreateDeckDTO(name: deck.name, language: deck.language ?? "")
        let result = await client.make(request: deckRequests.create(), body: dto, headers: try await headers())
        return try convertResult(result: result)
    }
    
    func update(deck: Deck) async throws -> Deck {
        let result = await client.make(request: deckRequests.update(at: deck.id), body: deck, headers: try await headers())
        return try convertResult(result: result)
    }
    
    func delete(deck: Deck) async throws {
        let result = await client.make(request: deckRequests.delete(at: deck.id), headers: try await headers())
        _ = try convertResult(result: result)
    }
}
