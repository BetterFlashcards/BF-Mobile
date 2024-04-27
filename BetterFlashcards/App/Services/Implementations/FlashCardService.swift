//
//  FlashCardService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

class FlashCardService: FlashCardServiceProtocol {
    private let flashCardRepo: any FlashCardRepositoryProtocol
    private let eventSubject = PassthroughSubject<FlashCardServiceEvent, Never>()
    
    var eventPublisher: AnyPublisher<BasicServiceEvent<FlashCard>, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(flashCardRepo: any FlashCardRepositoryProtocol) {
        self.flashCardRepo = flashCardRepo
    }
    
    func getList(for deckID: Deck.ID) async throws -> [FlashCard] {
        try await flashCardRepo.fetchAll(by: deckID)
    }
    
    func create(_ card: FlashCard) async throws -> FlashCard {
        let card = try await flashCardRepo.create(flashCard: card)
        eventSubject.send(.added(card))
        return card
    }
    
    func update(_ card: FlashCard) async throws -> FlashCard {
        let card = try await flashCardRepo.update(flashCard: card)
        eventSubject.send(.updated(card))
        return card
    }

    
    func delete(_ card: FlashCard) async throws -> FlashCard {
        try await flashCardRepo.delete(flashCard: card)
        eventSubject.send(.deleted(card))
        return card
    }
    
    func dueList(for deckID: Deck.ID) async throws -> [FlashCard] {
        try await flashCardRepo.dueCards(for: deckID)
    }
    
    func save(practice: FlashCardPractice) async throws {
        try await flashCardRepo.add(practice: practice)
    }
}
