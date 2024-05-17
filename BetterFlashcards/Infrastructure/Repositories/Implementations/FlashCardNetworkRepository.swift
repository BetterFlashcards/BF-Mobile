//
//  FlashCardNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

class FlashCardNetworkRepository: BaseAuthenticatedNetworking, FlashCardRepositoryProtocol {
    let flashCardRequests = FlashCardRequests.self
    
    func fetchAll(by deckID: Deck.ID) async throws -> [FlashCard] {
        try await client.make(request: flashCardRequests.list(for: deckID), headers: try await headers()).data.items.map(mapper(_:))
    }
    
    func fetch(by deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        let response = try await client.make(request: flashCardRequests.list(for: deckID), headers: try await headers(), queries: .init(pagination: pagination)).data
        
        return .init(
            items: response.items.map(self.mapper(_:)),
            count: response.count,
            pagination: pagination
        )
    }
    
    func fetch(by flashCardID: FlashCard.ID) async throws -> FlashCard? {
        nil
    }
    
    func create(flashCard: FlashCard) async throws -> FlashCard {
        let dto = CreateFlashCardDTO(
            frontWord: flashCard.frontWord,
            backWord: flashCard.backWord,
            isDraft: flashCard.isDraft,
            deckID: flashCard.deckID
        )
        return try await client.make(request: flashCardRequests.add(to: flashCard.deckID), body: dto, headers: try await headers()).data
    }
    
    func update(flashCard: FlashCard) async throws -> FlashCard {
        try await client.make(request: flashCardRequests.update(in: flashCard.deckID, cardID: flashCard.id), body: flashCard, headers: try await headers()).data
    }
    
    func delete(flashCard: FlashCard) async throws {
        _ = try await client.make(request: flashCardRequests.delete(from: flashCard.deckID, cardID: flashCard.id), headers: try await headers())
    }
    
    
    func dueCards(for deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        let response = try await client.make(request: flashCardRequests.due(for: deckID), headers: try await headers(), queries: .init(pagination: pagination)).data
        
        return .init(
            items: response.items.map(self.mapper(_:)),
            count: response.count,
            pagination: pagination
        )
    }
    
    func dueCards(for deckID: Deck.ID) async throws -> [FlashCard] {
        let response = try await client.make(request: flashCardRequests.due(for: deckID), headers: try await headers()).data
        return response.items.map(self.mapper(_:))
    }
    
    func add(practice: FlashCardPractice) async throws {
        let dto = FlashCardPracticeDTO(remembered: practice.result == .memorized)
        _ = try await client.make(request: flashCardRequests.updateReview(for: practice.flashCardID), body: dto, headers: try await headers())
    }
    
    private func mapper(_ dto: FlashCardResponseDTO) -> FlashCard {
        return FlashCard(
            id: dto.id,
            frontWord: dto.frontText,
            backWord: dto.backText,
            deckID: dto.deck.id,
            isDraft: false
        )
    }
}
