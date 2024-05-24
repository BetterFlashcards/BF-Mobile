//
//  Translation.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 24/05/2024.
//

import Foundation

struct Translation {
    let word: String
    let translation: String
    let id = UUID()
}

extension Translation: Codable, Identifiable { }
