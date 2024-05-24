//
//  LanguageServiceProtocol.swift
//  BetterFlashcards
//
//  Created by Majd Koshakji on 20/05/2024.
//

import Foundation

protocol LanguageServiceProtocol {
    func getList(at: Pagination) async throws -> PaginatedList<Language>
    func translate(word: String, from source: Language, to target: Language) async throws -> [Translation]
}
