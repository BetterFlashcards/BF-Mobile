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
    
    @Published var isLoading: Bool
    @Published var errorMessage: String?
    @Published var shouldDismiss: Bool
    
    init(id: Int? = nil, name: String, language: String) {
        self.id = id
        self.name = name
        self.language = language
        
        self.isLoading = false
        self.errorMessage = nil
        self.shouldDismiss = false
    }
}
