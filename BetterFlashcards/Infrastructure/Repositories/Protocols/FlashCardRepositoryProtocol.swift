//
//  FlashCardRepositoryProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

protocol FlashCardRepositoryProtocol {
    func fetchAll(by deckID: Deck.ID) async throws -> [FlashCard]
    func fetch(by flashCardID: FlashCard.ID) async throws -> FlashCard?
    func create(flashCard: FlashCard) async throws -> FlashCard
    func update(flashCard: FlashCard) async throws -> FlashCard
    func add(practice: FlashCardPractice) async throws -> FlashCard
    func delete(flashCard: FlashCard) async throws -> FlashCard
}
