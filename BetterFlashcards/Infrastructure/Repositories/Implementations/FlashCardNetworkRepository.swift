//
//  FlashCardNetworkRepository.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

class FlashCardNetworkRepository: BaseAuthenticatedNetworking, FlashCardRepositoryProtocol {
    let flashCardRequests = FlashCardRequests.self
    
    func fetch(by deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        let response = try await client.make(request: flashCardRequests.list(for: deckID), headers: try await headers(), queries: .init(pagination: pagination)).data
        
        return .init(
            items: response.items.map(self.toModel(_:)),
            count: response.count,
            pagination: pagination
        )
    }
    
    func fetch(by flashCardID: FlashCard.ID) async throws -> FlashCard? {
        nil
    }
    
    func create(flashCard: FlashCard) async throws -> FlashCard {
        let responseDTO = try await client.make(request: flashCardRequests.add(to: flashCard.deckID), body: toDTO(flashCard), headers: try await headers()).data
        return toModel(responseDTO)
    }
    
    func update(flashCard: FlashCard) async throws -> FlashCard {
        let dto = try await client.make(request: flashCardRequests.update(in: flashCard.deckID, cardID: flashCard.id), body: toDTO(flashCard), headers: try await headers()).data
        return toModel(dto)
    }
    
    func delete(flashCard: FlashCard) async throws {
        _ = try await client.make(request: flashCardRequests.delete(from: flashCard.deckID, cardID: flashCard.id), headers: try await headers())
    }
    
    
    func dueCards(for deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        let response = try await client.make(request: flashCardRequests.due(for: deckID), headers: try await headers(), queries: .init(pagination: pagination)).data
        
        return .init(
            items: response.items.map(self.toModel(_:)),
            count: response.count,
            pagination: pagination
        )
    }
    
    func add(practice: FlashCardPractice) async throws {
        let dto = FlashCardPracticeDTO(remembered: practice.result == .memorized)
        _ = try await client.make(request: flashCardRequests.updateReview(for: practice.flashCardID), body: dto, headers: try await headers())
    }
    
    private func toModel(_ dto: FlashCardDTO) -> FlashCard {
        return FlashCard(
            id: dto.id,
            frontWord: dto.frontText,
            backWord: dto.backText,
            deckID: dto.deckID,
            isDraft: dto.isDraft,
            relatedBookID: dto.relatedBookID
        )
    }
    
    private func toDTO(_ flashcard: FlashCard) -> FlashCardDTO {
        FlashCardDTO(
            id: flashcard.id,
            frontText: flashcard.frontWord,
            backText: flashcard.backWord,
            deckID: flashcard.deckID,
            isDraft: flashcard.isDraft,
            relatedBookID: flashcard.relatedBookID
        )
    }
}
