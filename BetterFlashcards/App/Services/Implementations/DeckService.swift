//
//  DeckService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

class DeckService: DeckServiceProtocol {
    private let deckRepo: any DeckRepositoryProtocol
    private let eventSubject = PassthroughSubject<DeckServiceEvent, Never>()
    
    var eventPublisher: AnyPublisher<DeckServiceEvent, Never> {
        self.eventSubject.eraseToAnyPublisher()
    }
    
    init(deckRepo: DeckRepositoryProtocol) {
        self.deckRepo = deckRepo
    }
    
    func getList(at pagination: Pagination) async throws -> PaginatedList<Deck> {
        try await deckRepo.fetch(at: pagination)
    }
    
    func create(_ deck: Deck) async throws -> Deck {
        let deck = try await deckRepo.create(deck: deck)
        eventSubject.send(.added(deck))
        return deck
    }
    
    func update(_ deck: Deck) async throws -> Deck {
        let deck = try await deckRepo.update(deck: deck)
        eventSubject.send(.updated(deck))
        return deck
    }
    
    func delete(_ deck: Deck) async throws -> Deck {
        try await deckRepo.delete(deck: deck)
        eventSubject.send(.deleted(deck))
        return deck
    }
}
