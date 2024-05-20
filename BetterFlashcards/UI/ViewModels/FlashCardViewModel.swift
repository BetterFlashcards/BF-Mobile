//
//  FlashCardViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

class FlashCardViewModel: BaseViewModel {
    @Published var id: FlashCard.ID?
    @Published var deckID: Deck.ID?
    @Published var frontText: String
    @Published var backText: String
    @Published var isDraft: Bool
    @Published var relatedBookID: Book.ID?
    
    var canSave: Bool { !frontText.isEmpty && !backText.isEmpty }
    var canSaveDraft: Bool { !frontText.isEmpty }

    @Published var isLoading: Bool

    init(id: FlashCard.ID? = nil, deckID: Deck.ID? = nil, frontText: String = "", backText: String = "", isDraft: Bool = false, relatedBookID: Book.ID? = nil, isLoading: Bool = false) {
        self.id = id
        self.deckID = deckID
        self.frontText = frontText
        self.backText = backText
        self.isDraft = isDraft
        self.relatedBookID = relatedBookID
        self.isLoading = isLoading
    }
    
    convenience init(from card: FlashCard) {
        self.init(
            id: card.id,
            deckID: card.deckID,
            frontText: card.frontWord,
            backText: card.backWord,
            isDraft: card.isDraft,
            relatedBookID: card.relatedBookID,
            isLoading: false
        )
    }
    
    func toCard() -> FlashCard {
        FlashCard(
            id: self.id ?? -1,
            frontWord: self.frontText,
            backWord: self.backText,
            deckID: self.deckID ?? -1,
            isDraft: self.isDraft,
            relatedBookID: self.relatedBookID
        )
    }
}
