//
//  TranslationViewModel.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import Foundation

class TranslationViewModel: BaseViewModel {
    let word: String
    @Published var source: Language?
    @Published var target: Language?
    @Published var translations: [Translation]?
    @Published var isLoading: Bool = false
    
    init(word: String) {
        self.word = word
        super.init()
    }
}
