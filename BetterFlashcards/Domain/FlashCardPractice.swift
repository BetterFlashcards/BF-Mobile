//
//  FlashCardPractice.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/04/2024.
//

import Foundation

struct FlashCardPractice {
    let flashCardID: FlashCard.ID
    let result: Result
    
    enum Result {
        case memorized, forgotten
    }
}
