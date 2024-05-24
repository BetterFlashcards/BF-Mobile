//
//  Language.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

struct Language {
    let id: Int
    let name: String
    let isocode: String
    let sorting: Int
}

extension Language: Codable, Identifiable { }
