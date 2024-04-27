//
//  FlashCardServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol FlashCardServiceProtocol {
    var eventPublisher: AnyPublisher<BasicServiceEvent<FlashCard>, Never> { get }

    func getList(for deckID: Deck.ID) async throws -> [FlashCard]
    func create(_: FlashCard) async throws -> FlashCard
    func update(_: FlashCard) async throws -> FlashCard
    func delete(_: FlashCard) async throws -> FlashCard
    
    func dueList(for deckID: Deck.ID) async throws -> [FlashCard]
    func save(practice: FlashCardPractice) async throws
}

typealias FlashCardServiceEvent = BasicServiceEvent<FlashCard>
