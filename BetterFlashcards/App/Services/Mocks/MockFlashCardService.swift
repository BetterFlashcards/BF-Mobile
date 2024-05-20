//
//  MockFlashCardService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

actor MockFlashCardService: FlashCardServiceProtocol {
    private var deckCards: [Deck.ID: [FlashCard]] = Dictionary(
        grouping: (0...100)
            .flatMap { deckID in
                (deckID...100).map { cardID in
                        FlashCard(
                            id: cardID,
                            frontWord: "Front-\(cardID)",
                            backWord: "Back-\(cardID)",
                            deckID: deckID,
                            isDraft: false
                        )
                    }
                
            },
        by: \.deckID
        )
    private let eventSubject = PassthroughSubject<FlashCardServiceEvent, Never>()
    private let pageSize = 20
    
    nonisolated var eventPublisher: AnyPublisher<FlashCardServiceEvent, Never> {
        self.eventSubject.eraseToAnyPublisher()
    }
    
    func getList(for deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        let cards = deckCards[deckID] ?? []
        let start = pagination.page * pagination.size
        let end = min(start + pagination.size, cards.count)
        guard start < end else { return .init(items: [], count: 0, pagination: pagination) }
        return .init(items: Array(cards[start..<end]), count: cards.count, pagination: pagination)
    }
    
    func create(_ card: FlashCard) async throws -> FlashCard {
        guard var deck = deckCards[card.deckID] else { throw ServiceError.notFound }
        deck.append(card)
        deckCards[card.deckID] = deck
        eventSubject.send(.added(card))
        return card
    }
    
    func update(_ card: FlashCard) async throws -> FlashCard {
        guard
            let idx = deckCards[card.deckID]?.firstIndex(of: card)
        else { throw ServiceError.notFound }

        deckCards[card.deckID]?[idx] = card
        eventSubject.send(.updated(card))
        return card
    }
    
    func delete(_ card: FlashCard) async throws -> FlashCard {
        guard
            let idx = deckCards[card.deckID]?.firstIndex(of: card)
        else { throw ServiceError.notFound }
        
        deckCards[card.deckID]?.remove(at: idx)
        eventSubject.send(.deleted(card))
        return card
    }
    
    func dueList(for deckID: Deck.ID, at pagination: Pagination) async throws -> PaginatedList<FlashCard> {
        try await getList(for: deckID, at: pagination)
    }
    
    func save(practice: FlashCardPractice) async throws {
        
    }
}
