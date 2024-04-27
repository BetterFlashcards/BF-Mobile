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
    
    func getList() async throws -> [Deck] {
        return deckList
    }

    func getList(at page: Int) async throws -> [Deck] {
        let start = page * pageSize
        let end = min(start + pageSize, deckList.count)
        guard start < end else { return [] }
        return Array(deckList[start..<end])
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
