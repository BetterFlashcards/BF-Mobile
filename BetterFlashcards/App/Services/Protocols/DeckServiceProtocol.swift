//
//  DeckServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol DeckServiceProtocol: GenericBasicServiceProtocol where Item == Deck {
    func getList(at: Pagination) async throws -> PaginatedList<Item>
}

typealias DeckServiceEvent = BasicServiceEvent<Deck>
