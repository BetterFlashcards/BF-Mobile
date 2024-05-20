//
//  DeckViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 27/04/2024.
//

import Foundation

class DeckViewModel: BaseViewModel {
    @Published var id: Deck.ID?
    @Published var name: String
    @Published var language: String
    @Published var cardCount: Int

    @Published var isLoading: Bool
    
    var hasCards: Bool { cardCount > 0 }
    
    init(id: Int? = nil, name: String, language: String, cardCount: Int = 0) {
        self.id = id
        self.name = name
        self.language = language
        self.cardCount = cardCount
        
        self.isLoading = false
    }
    
    func toDeck() -> Deck {
        Deck(id: self.id ?? -1, name: self.name, language: self.language)
    }
}
