//
//  FlashCardService.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation


class FlashCardService: FlashCardServiceProtocol {
    let flashCardRepo: any FlashCardRepositoryProtocol
    
    init(flashCardRepo: any FlashCardRepositoryProtocol) {
        self.flashCardRepo = flashCardRepo
    }
}
