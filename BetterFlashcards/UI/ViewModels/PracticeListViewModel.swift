//
//  PracticeListViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

class PracticeListViewModel: ListViewModel<FlashCard> {
    @Published var currentItem: PracticeItemViewModel?
    
    func nextCard() {
        guard let next = self.list.first else {
            self.currentItem = nil
            return
        }
        self.currentItem = PracticeItemViewModel(card: next, flipped: false)
        self.list.remove(id: next.id)
    }
}

class PracticeItemViewModel: ObservableObject {
    @Published var card: FlashCard
    @Published var flipped: Bool
    
    init(card: FlashCard, flipped: Bool) {
        self.card = card
        self.flipped = flipped
    }
}
