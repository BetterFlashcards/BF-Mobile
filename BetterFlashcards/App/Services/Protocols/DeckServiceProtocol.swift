//
//  DeckServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation
import Combine

protocol DeckServiceProtocol: GenericBasicServiceProtocol where Item == Deck { }

typealias DeckServiceEvent = BasicServiceEvent<Deck>
