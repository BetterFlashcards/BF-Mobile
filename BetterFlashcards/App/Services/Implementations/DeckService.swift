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
    
    func getList() async throws -> [Deck] {
        try await deckRepo.fetchAll()
    }
    
    func create(_ deck: Deck) async throws -> Deck {
        try await deckRepo.create(deck: deck)
    }
    
    func update(_ deck: Deck) async throws -> Deck {
        try await deckRepo.update(deck: deck)
    }
    
    func delete(_ deck: Deck) async throws -> Deck {
        try await deckRepo.delete(deck: deck)
    }
}