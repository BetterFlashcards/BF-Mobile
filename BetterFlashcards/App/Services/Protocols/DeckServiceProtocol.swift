//
//  DeckServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol DeckServiceProtocol: GenericBasicServiceProtocol where Item == Deck, Event == DeckServiceEvent {
    
}

enum DeckServiceEvent {
    case added(Deck)
    case updated(Deck)
    case deleted(Deck)
}
