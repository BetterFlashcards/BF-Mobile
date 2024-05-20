//
//  MockDeckService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

actor MockDeckService: DeckServiceProtocol {
    private var deckList = (0...100).map {
        Deck(id: $0, name: "Deck \($0)", language: "en")
    }
    private let eventSubject = PassthroughSubject<DeckServiceEvent, Never>()
    private let pageSize = 20
    
    nonisolated var eventPublisher: AnyPublisher<DeckServiceEvent, Never> {
        self.eventSubject.eraseToAnyPublisher()
    }
    
    func getList(at pagination: Pagination) async throws -> PaginatedList<Deck> {
        let start = pagination.page * pagination.size
        let end = min(start + pagination.size, deckList.count)
        guard start < end else { return .init(items: [], count: 0, pagination: pagination) }
        return .init(items: Array(deckList[start..<end]), count: deckList.count, pagination: pagination)
    }
    
    func create(_ deck: Deck) async throws -> Deck {
        deckList.append(deck)
        eventSubject.send(.added(deck))
        return deck
    }
    
    func update(_ deck: Deck) async throws -> Deck {
        guard let index = deckList.firstIndex(where: { $0.id == deck.id })
        else {
            throw ServiceError.notFound
        }
        deckList[index] = deck
        eventSubject.send(.updated(deck))
        return deck
    }
    
    func delete(_ deck: Deck) async throws -> Deck {
        guard let index = deckList.firstIndex(where: { $0.id == deck.id })
        else {
            throw ServiceError.notFound
        }
        deckList.remove(at: index)
        eventSubject.send(.deleted(deck))
        return deck
    }
    
}
